import UIKit
import WebKit
import Turbolinks
import ContactsUI
import EventKit
import EventKitUI

class NavigationController: UINavigationController {
  var applicationController: ApplicationController?
  var currentVisitableViewController: VisitableViewController?

  func visit(_ url: URL, action: String = "advance") {
    print("visiting url \(url)")

    var action = action

    let pathsToResetNavigation = [
      "/sign_out",
      "/mobile/welcome",
      "/mobile/dashboard"
    ]

    if pathsToResetNavigation.contains(url.path) {
      action = "root"
    }

    presentVisitableViewController(url, action: action)
  }

  func currentWebView() -> WKWebView {
    return (applicationController?.turbolinksSession.topmostVisitable?.visitableView.webView)!
  }
}

// MARK: Present view controllers

extension NavigationController {
  func showViewControllerAsRoot(_ viewController: UIViewController) {
    popToRootViewController(animated: true)
    setViewControllers([viewController], animated: false)
  }

  func replaceCurrentViewControllerWith(_ viewController: UIViewController) {
    popViewController(animated: false)
    pushViewController(viewController, animated: false)
  }

  func presentRootController() {
    visit(applicationController!.dashboardUrl!)
  }

  func presentVisitableViewController(_ url: URL, action: String) {

    let visitableViewController = VisitableViewController(url: url)
    visitableViewController.applicationController = self.applicationController

    currentVisitableViewController = visitableViewController

    if action == "advance" {
      pushViewController(visitableViewController, animated: true)
    } else if action == "replace" {
      replaceCurrentViewControllerWith(visitableViewController)
    } else if action == "root" {
      showViewControllerAsRoot(visitableViewController)
    } else if action == "fullscreen" {
      let fullscreenVisitableViewController = FullscreenVisitableViewController(url: url)
      fullscreenVisitableViewController.applicationController = self.applicationController
      let fullscreenNavigationController = FullscreenNavigationController()
      fullscreenNavigationController.applicationController = self.applicationController
      fullscreenNavigationController.present(viewController: fullscreenVisitableViewController)
      currentVisitableViewController = fullscreenVisitableViewController
      fullscreenNavigationController.enterFullscreen()
    } else {
      fatalError("Action \(action) not handled.")
    }

    preferSplitScreen()
    applicationController!.turbolinksSession.visit(currentVisitableViewController!)
  }

  func presentContactsViewController(_ url: URL) {
    let contactsViewController = ContactsViewController(url: url)
    contactsViewController.applicationController = self.applicationController
    currentVisitableViewController = contactsViewController
    pushViewController(contactsViewController, animated: true)
    preferSplitScreen()
    applicationController!.turbolinksSession.visit(contactsViewController)
  }

  func presentContactViewController(_ vcardString: String) {
    let vcardData = vcardString.data(using: String.Encoding.utf8)
    let contactViewController = CNContactViewController(vcardData: vcardData!)
    preferSplitScreen()
    showDetailViewController(contactViewController, sender: self)
  }

  func presentContactViewController(url: URL) {
    let webView = (self.viewControllers.first as! VisitableViewController).visitableView.webView!
    webView.readUrlContent(url) { (result: String) in
      self.presentContactViewController(result)
    }

  }

  func presentPdfViewController(_ url: URL) {
    let pdfViewController = PdfViewController(url: url, webViewConfiguration: self.applicationController!.webViewConfiguration)
    self.applicationController?.splitViewController?.showDetailViewController(pdfViewController, sender: self)
  }
//  func presentEventViewController(icsString: String) {
//    let eventViewController = EventViewController(icsString: icsString)
//    pushViewController(eventViewController, animated: true)
//  }

  func presentEventViewController(_ url: URL) {
    let eventViewController = WebViewController(url: url, webViewConfiguration: self.applicationController!.webViewConfiguration)
    preferSplitScreen()
    showDetailViewController(eventViewController, sender: self)
  }

  func presentMapViewController(_ url: URL) {
    let mapViewController = MapViewController()
    mapViewController.applicationController = self.applicationController
    pushViewController(mapViewController, animated: true)
  }

  func presentPhotoIndexViewController(_ url: URL) {
    // Case: Switch current visitable to full screen mode and navigate to the
    // given photo index url.
    visit(url, action: "fullscreen")
    //(applicationController!.window!.rootViewController as! FullscreenVisitableViewController).setLoadingText(text: "Fotos laden ...")
  }

  func presentAuthenticationViewController(_ url: URL) {
    let authenticationViewController = AuthenticationViewController()
    authenticationViewController.delegate = self
    authenticationViewController.webViewProcessPool = applicationController!.webViewProcessPool
    authenticationViewController.URL = applicationController?.signInUrl
    pushViewController(authenticationViewController, animated: true)
  }

  func preferFullscreen() {
    (splitViewController as! SplitViewController).preferFullscreenContent()
  }

  func preferSplitScreen() {
    (splitViewController as! SplitViewController).preferSplitScreenContent()
  }

}

// MARK: Handle incoming navigation messages from javascript

extension NavigationController: WKScriptMessageHandler {

  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    if let message = message.body as? String {

      if message == "enterFullscreen" {
        enterFullscreen()
      } else if message == "leaveFullscreen" {
        leaveFullscreen()
      } else {
        presentContactViewController(message)
      }
    }
  }

  func enterFullscreen() {
    let fullscreenVisitableViewController = FullscreenVisitableViewController()
    fullscreenVisitableViewController.applicationController = applicationController
    fullscreenVisitableViewController.takeOverWebView(from: currentVisitableViewController!)
    fullscreenVisitableViewController.enterFullscreen()
  }

  func leaveFullscreen() {
    let fullscreenNavigationController = (applicationController?.window?.rootViewController as! FullscreenNavigationController)
    let fullscreenVisitableViewController = fullscreenNavigationController.viewControllers.first as! FullscreenVisitableViewController
    fullscreenVisitableViewController.putWebViewBack(to: applicationController!.turbolinksSession.topmostVisitable!)
    fullscreenNavigationController.leaveFullscreen()
  }

}

extension NavigationController: SessionDelegate {
  func session(_ session: Session, didProposeVisitToURL URL: Foundation.URL, withAction action: Action) {
    print("proposed url: \(URL)")

    if URL.path.contains("/sign_in") {
      presentAuthenticationViewController(applicationController!.dashboardUrl! as URL)
    } else if URL.path.contains("/mobile/contacts") {
      presentContactsViewController(URL)
    } else if URL.path.contains("/mobile/nearby_locations") {
      presentMapViewController(URL)
    } else if URL.path.contains("/mobile/photos") {
      presentPhotoIndexViewController(URL)
    } else {
      visit(URL, action: action.rawValue)
    }
  }

  func session(_ session: Session, didFailRequestForVisitable visitable: Visitable, withError error: NSError) {
    NSLog("ERROR: %@", error)
    guard let visitableViewController = visitable as? VisitableViewController, let errorCode = ErrorCode(rawValue: error.code) else { return }



    switch errorCode {
      case .httpFailure:
        let statusCode = error.userInfo["statusCode"] as! Int
        switch statusCode {
          case 401:
            presentAuthenticationViewController(visitable.visitableURL)
          case 404:
             visitableViewController.presentError(.HTTPNotFoundError)
          default:
             visitableViewController.presentError(Error(HTTPStatusCode: statusCode))
        }
      case .networkFailure:
        visitableViewController.presentError(.NetworkError)
    }
  }

  func sessionDidStartRequest(_ session: Session) {
    applicationController!.application.isNetworkActivityIndicatorVisible = true
  }

  func sessionDidFinishRequest(_ session: Session) {
    applicationController!.application.isNetworkActivityIndicatorVisible = false
    if let fullscreenViewController = currentVisitableViewController as? FullscreenVisitableViewController {
      fullscreenViewController.loadingLabel.text = ""
    }
  }

  func sessionDidLoadWebView(_ session: Session) {
    session.webView.navigationDelegate = self
    session.webView.uiDelegate = self
  }

}

// MARK: Handle which documents to show in the web view.

extension NavigationController: WKNavigationDelegate {

  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> ()) {

    // This method is called whenever the webView within the
    // visitableView attempts a navigation action. By default, the
    // navigation has to be cancelled, since when clicking a
    // turbolinks link, the content is shown in a **new**
    // visitableView.
    //
    // But there are exceptions: When clicking on a PDF, which
    // is not handled by turbolinks, we have to handle showing
    // the pdf manually.
    //
    // We can't just allow the navigation since this would not
    // create a new visitable controller, i.e. there would be
    // no back button to the documents index. Therefore, we have
    // to create a new view controller manually.

    let url = navigationAction.request.url!

    if url.pathExtension == "pdf" {
      presentPdfViewController(url)
    }

    if url.pathExtension == "vcf" {
      webView.readUrlContent(url) { (result: String) in
        self.presentContactViewController(result)
      }
    }

    // Calendar Subscriptions
    if url.absoluteString.contains("webcal://") {
      // https://stackoverflow.com/a/25945530/2066546
      UIApplication.shared.openURL(url)
    }


//    if url.pathExtension == "ics" {
//      let store = EKEventStore()
//      store.requestAccessToEntityType(.Event) { (granted: Bool, error: NSError?) in
//        let event = EKEvent(eventStore: store)
//        event.title = "Foo"
//
//        let controller = EKEventViewController()
//        controller.event = event
//        controller.allowsEditing = false
//        controller.delegate = self
//
//        self.presentViewController(controller, animated: true) { () in
//          print("complete")
//        }
//
//
//        // TODO: http://stackoverflow.com/questions/28379603/how-to-add-an-event-in-the-device-calendar-using-swift
//      }
//    }

    // External Links
    if url.host != applicationController!.entryPointUrl!.host {
      UIApplication.shared.openURL(url)
    }

    // Emails
    if url.scheme?.lowercased() == "mailto" {
      UIApplication.shared.openURL(url)
    }

    decisionHandler(WKNavigationActionPolicy.cancel)
  }

}

extension NavigationController: WKUIDelegate {

  func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
    if navigationAction.targetFrame == nil {
      webView.load(navigationAction.request)
    }
    return nil
  }

}

extension NavigationController: EKEventViewDelegate {
  func eventViewController(_ controller: EKEventViewController, didCompleteWith action: EKEventViewAction) {
  }
}

extension NavigationController: AuthenticationViewControllerDelegate {
  func authenticationViewControllerDidAuthenticate(_ authenticationViewController: AuthenticationViewController) {
    popViewController(animated: true)
    visit(applicationController!.dashboardUrl! as URL)
  }
}

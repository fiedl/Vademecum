import UIKit
import WebKit
import Turbolinks
import ContactsUI
import EventKit
import EventKitUI

class NavigationController: UINavigationController {
  var applicationController: ApplicationController?

  func visit(url: NSURL, action: String = "advance") {
    print("visiting url \(url)")

    var action = action

    let pathsToResetNavigation = [
      "/sign_out",
      "/mobile/welcome",
      "/mobile/dashboard"
    ]

    if pathsToResetNavigation.contains(url.path!) {
      action = "root"
    }

//    if url.path!.containsString("/events/") {
//      presentEventViewController(url)
//    } else {
      presentVisitableViewController(url, action: action)
//    }
  }

  func currentWebView() -> WKWebView {
    return (applicationController?.turbolinksSession.topmostVisitable?.visitableView.webView)!
  }
}

// MARK: Present view controllers

extension NavigationController {
  func showViewControllerAsRoot(viewController: UIViewController) {
    popToRootViewControllerAnimated(true)
    setViewControllers([viewController], animated: false)
  }

  func replaceCurrentViewControllerWith(viewController: UIViewController) {
    popViewControllerAnimated(false)
    pushViewController(viewController, animated: false)
  }

  func presentVisitableViewController(url: NSURL, action: String) {

    let visitableViewController = VisitableViewController(URL: url)
    visitableViewController.applicationController = self.applicationController

    if action == "advance" {
      pushViewController(visitableViewController, animated: true)
    } else if action == "replace" {
      replaceCurrentViewControllerWith(visitableViewController)
    } else if action == "root" {
      showViewControllerAsRoot(visitableViewController)
    } else {
      fatalError("Action \(action) not handled.")
    }

    preferSplitScreen()
    applicationController!.turbolinksSession.visit(visitableViewController)
  }

  func presentContactViewController(vcardString vcardString: String) {
    let vcardData = vcardString.dataUsingEncoding(NSUTF8StringEncoding)
    let contactViewController = CNContactViewController(vcardData: vcardData!)
    preferSplitScreen()
    showDetailViewController(contactViewController, sender: self)
  }

  func presentPdfViewController(url: NSURL) {
    let pdfViewController = PdfViewController(url: url, webViewConfiguration: self.applicationController!.webViewConfiguration)
    self.applicationController?.splitViewController?.showDetailViewController(pdfViewController, sender: self)
  }

//  func presentEventViewController(icsString: String) {
//    let eventViewController = EventViewController(icsString: icsString)
//    pushViewController(eventViewController, animated: true)
//  }

  func presentEventViewController(url: NSURL) {
    let eventViewController = WebViewController(url: url, webViewConfiguration: self.applicationController!.webViewConfiguration)
    preferSplitScreen()
    showDetailViewController(eventViewController, sender: self)
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
  func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
    if let message = message.body as? String {
      presentContactViewController(vcardString: message)
    }
  }
}

extension NavigationController: SessionDelegate {
  func session(session: Session, didProposeVisitToURL URL: NSURL, withAction action: Action) {
    print("proposed url: \(URL)")
    visit(URL, action: action.rawValue)
  }

  func session(session: Session, didFailRequestForVisitable visitable: Visitable, withError error: NSError) {
    NSLog("ERROR: %@", error)
    guard let visitableViewController = visitable as? VisitableViewController, errorCode = ErrorCode(rawValue: error.code) else { return }
    
    switch errorCode {
      case .HTTPFailure:
        let statusCode = error.userInfo["statusCode"] as! Int
        switch statusCode {
          case 401:
            fatalError("Authentication errors should be handled by the server. The user is presented a sign-in form by the server.")
          case 404:
             visitableViewController.presentError(.HTTPNotFoundError)
          default:
             visitableViewController.presentError(Error(HTTPStatusCode: statusCode))
        }
      case .NetworkFailure:
        visitableViewController.presentError(.NetworkError)
    }
  }

  func sessionDidStartRequest(session: Session) {
    applicationController!.application.networkActivityIndicatorVisible = true
  }

  func sessionDidFinishRequest(session: Session) {
    applicationController!.application.networkActivityIndicatorVisible = false
  }

  func sessionDidLoadWebView(session: Session) {
    session.webView.navigationDelegate = self
    session.webView.UIDelegate = self
  }

}

// MARK: Handle which documents to show in the web view.

extension NavigationController: WKNavigationDelegate {

  func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> ()) {

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

    let url = navigationAction.request.URL!

    if url.pathExtension == "pdf" {
      presentPdfViewController(url)
    }

    if url.pathExtension == "vcf" {
      webView.readUrlContent(url) { (result: String) in
        self.presentContactViewController(vcardString: result)
      }
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
      UIApplication.sharedApplication().openURL(url)
    }

    // Emails
    if url.scheme.lowercaseString == "mailto" {
      UIApplication.sharedApplication().openURL(url)
    }

    decisionHandler(WKNavigationActionPolicy.Cancel)

  }

}

extension NavigationController: WKUIDelegate {

  func webView(webView: WKWebView, createWebViewWithConfiguration configuration: WKWebViewConfiguration, forNavigationAction navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
    if navigationAction.targetFrame == nil {
      webView.loadRequest(navigationAction.request)
    }
    return nil
  }

}

extension NavigationController: EKEventViewDelegate {
  func eventViewController(controller: EKEventViewController, didCompleteWithAction action: EKEventViewAction) {
  }

}
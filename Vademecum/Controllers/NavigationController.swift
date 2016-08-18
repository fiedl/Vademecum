import UIKit
import WebKit
import Turbolinks
import ContactsUI

class NavigationController: UINavigationController {
  var applicationController: ApplicationController?
  var currentUrl: NSURL?
  var didReload: Bool = false

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

    currentUrl = url
    didReload = false
    presentVisitableViewController(url, action: action)
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

    applicationController!.turbolinksSession.visit(visitableViewController)
  }

  func presentContactViewController(vcardString vcardString: String) {
    let vcardData = vcardString.dataUsingEncoding(NSUTF8StringEncoding)
    let contactViewController = CNContactViewController(vcardData: vcardData!)
    pushViewController(contactViewController, animated: true)
  }

  func presentPdfViewController(url: NSURL) {
    let pdfViewController = PdfViewController(URL: url)
    pdfViewController.applicationController = self.applicationController
    pushViewController(pdfViewController, animated: true)
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

    decisionHandler(WKNavigationActionPolicy.Cancel)

  }

}
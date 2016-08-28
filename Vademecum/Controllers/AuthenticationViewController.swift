import UIKit
import WebKit

protocol AuthenticationViewControllerDelegate: class {
  func authenticationViewControllerDidAuthenticate(authenticationViewController: AuthenticationViewController)
}

enum AuthenticationState {
  case None
  case SignInPage
  case Callback
  case Dashboard
}

class AuthenticationViewController: UIViewController {

  var URL: NSURL?
  var state: AuthenticationState = .None

  var webViewProcessPool: WKProcessPool?
  weak var delegate: AuthenticationViewControllerDelegate?

  lazy var webView: WKWebView = {
    let configuration = WKWebViewConfiguration()
    configuration.processPool = self.webViewProcessPool!

    let webView = WKWebView(frame: CGRectZero, configuration: configuration)
    webView.translatesAutoresizingMaskIntoConstraints = false
    webView.navigationDelegate = self
    return webView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    self.title = "Anmelden"

    view.addSubview(webView)
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: [], metrics: nil, views: [ "view": webView ]))
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: [], metrics: nil, views: [ "view": webView ]))

    if let URL = self.URL {
      webView.loadRequest(NSURLRequest(URL: URL))
    }
  }
}

extension AuthenticationViewController: WKNavigationDelegate {
  func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {

    let url = navigationAction.request.URL!

    print(state)
    print(url)

    // TODO: Sign-In-Formular doch nicht mit Turbolinks. Sonst wird diese
    // Methode hier nicht getriggert.

    if self.state == .None && url.absoluteString.containsString("/sign_in") {
      self.state = .SignInPage
//    } else if self.state == .SignInPage && url.absoluteString.containsString("/callback") {
//      self.state = .Callback
    } else if self.state == .SignInPage && url.absoluteString.containsString("/dashboard") {
      self.state = .Dashboard
    }

    if self.state == .Dashboard {
      decisionHandler(.Cancel)
      delegate?.authenticationViewControllerDidAuthenticate(self)
      return
    }

    decisionHandler(.Allow)
  }
}
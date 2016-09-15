import UIKit
import WebKit

protocol AuthenticationViewControllerDelegate: class {
  func authenticationViewControllerDidAuthenticate(_ authenticationViewController: AuthenticationViewController)
}

enum AuthenticationState {
  case none
  case signInPage
  case callback
  case dashboard
}

class AuthenticationViewController: UIViewController {

  var URL: Foundation.URL?
  var state: AuthenticationState = .none

  var webViewProcessPool: WKProcessPool?
  weak var delegate: AuthenticationViewControllerDelegate?

  lazy var webView: WKWebView = {
    let configuration = WKWebViewConfiguration()
    configuration.processPool = self.webViewProcessPool!

    let webView = WKWebView(frame: CGRect.zero, configuration: configuration)
    webView.translatesAutoresizingMaskIntoConstraints = false
    webView.navigationDelegate = self
    return webView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    self.title = "Anmelden"

    view.addSubview(webView)
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: [ "view": webView ]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: [ "view": webView ]))

    if let URL = self.URL {
      webView.load(URLRequest(url: URL))
    }
  }
}

extension AuthenticationViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

    let url = navigationAction.request.url!

    print(state)
    print(url)

    // TODO: Sign-In-Formular doch nicht mit Turbolinks. Sonst wird diese
    // Methode hier nicht getriggert.

    if self.state == .none && url.absoluteString.contains("/sign_in") {
      self.state = .signInPage
//    } else if self.state == .SignInPage && url.absoluteString.containsString("/callback") {
//      self.state = .Callback
    } else if self.state == .signInPage && url.absoluteString.contains("/dashboard") {
      self.state = .dashboard
    }

    if self.state == .dashboard {
      decisionHandler(.cancel)
      delegate?.authenticationViewControllerDidAuthenticate(self)
      return
    }

    decisionHandler(.allow)
  }
}

import WebKit

class WebViewController: UIViewController {
  var url: NSURL?
  var webViewConfiguration: WKWebViewConfiguration?

  convenience init(url: NSURL) {
    self.init()
    self.url = url
  }

  convenience init(url: NSURL, webViewConfiguration: WKWebViewConfiguration) {
    self.init(url: url)
    self.webViewConfiguration = webViewConfiguration
  }

  lazy var webView: WKWebView = {
    return WKWebView(frame: CGRectZero, configuration: self.webViewConfiguration!)
  }()

  lazy var filename: String? = {
    return self.url?.pathComponents?.last
  }()

  override func viewDidLoad() {
    view.addSubview(webView)
    webView.bindFrameToSuperviewBounds()  // http://stackoverflow.com/a/32824659/2066546
    self.title = filename  // http://stackoverflow.com/a/39022302/2066546
    webView.loadRequest(NSURLRequest(URL: self.url!))
    webView.navigationDelegate = self
  }

}

extension WebViewController: WKNavigationDelegate {

  func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
  }
  
}

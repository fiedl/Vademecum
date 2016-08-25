import WebKit

class FileViewController: UIViewController {
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

  lazy var fileView: WKWebView = {
    return WKWebView(frame: CGRectZero, configuration: self.webViewConfiguration!)
  }()

  lazy var filename: String? = {
    return self.url?.pathComponents?.last
  }()

  override func viewDidLoad() {
    view.addSubview(fileView)
    fileView.bindFrameToSuperviewBounds()  // http://stackoverflow.com/a/32824659/2066546
    self.title = filename  // http://stackoverflow.com/a/39022302/2066546
    fileView.loadRequest(NSURLRequest(URL: self.url!))
    fileView.navigationDelegate = self
  }

}

extension FileViewController: WKNavigationDelegate {

  func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
    let split = self.splitViewController as! SplitViewController
    split.preferFullscreenContent()
  }

}

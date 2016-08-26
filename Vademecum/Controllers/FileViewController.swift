import WebKit

class FileViewController: WebViewController {

  override func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
    super.webView(webView, didFinishNavigation: navigation)

    let split = self.splitViewController as! SplitViewController
    split.preferFullscreenContent()
  }

}

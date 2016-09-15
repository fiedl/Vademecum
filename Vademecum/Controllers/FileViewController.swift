import WebKit

class FileViewController: WebViewController {

  override func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    super.webView(webView, didFinish: navigation)

    let split = self.splitViewController as! SplitViewController
    split.preferFullscreenContent()
  }

}

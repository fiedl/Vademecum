import WebKit

class PhotoViewController: WebViewController {
  var contentInsetTopBackup: CGFloat = 0

  override func viewDidLoad() {
    let mainWebView = applicationController!.navigationController!.currentVisitableViewController!.visitableView.webView!

    webView = mainWebView
    self.view.addSubview(webView)
    webView.frame = CGRect.zero
    webView.bindFrameToSuperviewBounds()
    self.view.backgroundColor = UIColor.black
    self.webView.backgroundColor = UIColor.black
    self.webView.isOpaque = false

    contentInsetTopBackup = self.webView.scrollView.contentInset.top
    self.webView.scrollView.contentInset.top = 0
  }

  override var prefersStatusBarHidden: Bool {
    return true
  }

  func restoreWebView() {
    webView.backgroundColor = applicationController?.webAppBackgroundColor
    webView.scrollView.contentInset.top = contentInsetTopBackup
  }

}

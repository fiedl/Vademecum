import WebKit

class FileViewController: VisitableViewController {

  lazy var fileView: WKWebView = {
    return WKWebView(frame: CGRectZero, configuration: self.applicationController!.webViewConfiguration)
  }()

  lazy var filename: String? = {
    return self.visitableURL?.pathComponents?.last
  }()

  override func viewDidLoad() {
    view.addSubview(fileView)
    fileView.bindFrameToSuperviewBounds()  // http://stackoverflow.com/a/32824659/2066546
    self.title = filename  // http://stackoverflow.com/a/39022302/2066546
    fileView.loadRequest(NSURLRequest(URL: visitableURL))
  }

}

import WebKit
import Turbolinks

class FullscreenVisitableViewController: VisitableViewController {

  lazy var loadingLabel: UILabel = {
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    //label.center = CGPoint(x: 160, y: 285)
    label.center = CGPoint(x: 160, y: 185)
    label.textAlignment = .center
    label.text = "Laden ..."
    label.textColor = UIColor.white
    return label
  }()

//  override func viewDidLoad() {
//    super.viewDidLoad()
//  }

  func takeOverWebView(from: Turbolinks.Visitable) {
    self.visitableView.activateWebView(from.visitableView.webView!, forVisitable: from)
  }

  func putWebViewBack(to: Turbolinks.Visitable) {
    to.visitableView.activateWebView(self.visitableView.webView!, forVisitable: to)
  }

  func enterFullscreen() {
    setBackgroundColor(color: UIColor.black)
    applicationController!.window!.rootViewController = self
  }

  func leaveFullscreen() {
    setBackgroundColor(color: (applicationController?.webAppBackgroundColor)!)
    applicationController!.window!.rootViewController = applicationController!.splitViewController
  }

  func setBackgroundColor(color: UIColor) {
    self.view.backgroundColor = color
    visitableView.backgroundColor = color
    visitableView.webView?.backgroundColor = color
    visitableView.webView?.isOpaque = false
  }

  func setLoadingText(text: String) {
    self.loadingLabel.text = text
    self.view.addSubview(loadingLabel)
  }

  override var prefersStatusBarHidden: Bool {
    return true
  }



}

import Turbolinks
import UIKit

class VisitableViewController: Turbolinks.VisitableViewController {
  var applicationController: ApplicationController?

  override func viewDidLoad() {
    super.viewDidLoad()

    if let applicationController = applicationController {
      visitableView.backgroundColor = applicationController.webAppBackgroundColor
    }

    visitableView.webView?.scrollView.maximumZoomScale = 1.0
    visitableView.webView?.scrollView.minimumZoomScale = 1.0
  }

  lazy var errorView: ErrorView = {
    let view = NSBundle.mainBundle().loadNibNamed("ErrorView", owner: self, options: nil).first as! ErrorView
    view.translatesAutoresizingMaskIntoConstraints = false
    view.retryButton.addTarget(self, action: #selector(retry(_:)), forControlEvents: .TouchUpInside)
    return view
  }()

  func presentError(error: Error) {
    errorView.error = error
    view.addSubview(errorView)
    installErrorViewConstraints()
  }

  func installErrorViewConstraints() {
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: [], metrics: nil, views: [ "view": errorView ]))
    view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: [], metrics: nil, views: [ "view": errorView ]))
  }

  func retry(sender: AnyObject) {
    errorView.removeFromSuperview()
    reloadVisitable()
  }
}
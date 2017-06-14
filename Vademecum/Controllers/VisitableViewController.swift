import Turbolinks
import UIKit

class VisitableViewController: Turbolinks.VisitableViewController {
  var applicationController: ApplicationController?

  override func viewDidLoad() {
    super.viewDidLoad()

    if let applicationController = applicationController {
      visitableView.backgroundColor = applicationController.webAppBackgroundColor
    }

    // https://stackoverflow.com/a/40263064/2066546
    NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)

  }

  func rotated() {
    // This does nothing, but may be overridden to resize controls on device orientation change.

    //    if UIDevice.current.orientation.isLandscape {
    //      print("Landscape")
    //    } else {
    //      print("Portrait")
    //    }
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  override func willMove(toParentViewController parent: UIViewController?) {
    // This is the "back" button: http://stackoverflow.com/a/32667598/2066546
    super.willMove(toParentViewController: parent)

    applicationController?.navigationController?.preferSplitScreen()
    if splitViewController?.viewControllers.last! is PdfViewController {
      splitViewController?.viewControllers = [(splitViewController?.viewControllers.first)!, EmptyViewController()]
    }
  }

  lazy var errorView: ErrorView = {
    let view = Bundle.main.loadNibNamed("ErrorView", owner: self, options: nil)?.first as! ErrorView
    view.translatesAutoresizingMaskIntoConstraints = false
    view.retryButton.addTarget(self, action: #selector(retry(_:)), for: .touchUpInside)
    return view
  }()

  func presentError(_ error: Error) {
    errorView.error = error
    view.addSubview(errorView)
    installErrorViewConstraints()
  }

  func installErrorViewConstraints() {
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: [ "view": errorView ]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: [ "view": errorView ]))
  }

  func retry(_ sender: AnyObject) {
    errorView.removeFromSuperview()
    reloadVisitable()
  }
}

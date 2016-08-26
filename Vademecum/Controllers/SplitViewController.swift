import UIKit

class SplitViewController: UISplitViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    self.delegate = self
  }

  func preferFullscreenContent() {
    self.preferredDisplayMode = .Automatic
  }

  func preferSplitScreenContent() {
    self.preferredDisplayMode = .AllVisible
  }

}

extension SplitViewController : UISplitViewControllerDelegate {

  func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
    if secondaryViewController is EmptyViewController {
      return true
    } else {
      return false
    }
  }

}
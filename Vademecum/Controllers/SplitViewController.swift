import UIKit

class SplitViewController: UISplitViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    self.delegate = self
  }

  func preferFullscreenContent() {
    self.preferredDisplayMode = .automatic
  }

  func preferSplitScreenContent() {
    self.preferredDisplayMode = .allVisible
  }

}

extension SplitViewController : UISplitViewControllerDelegate {

  func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
    if secondaryViewController is EmptyViewController {
      return true
    } else {
      return false
    }
  }

}

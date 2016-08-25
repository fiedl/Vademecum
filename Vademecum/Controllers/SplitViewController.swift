import UIKit

class SplitViewController: UISplitViewController {

  func preferFullscreenContent() {
    self.preferredDisplayMode = .Automatic
  }

  func preferSplitScreenContent() {
    self.preferredDisplayMode = .AllVisible
  }

}
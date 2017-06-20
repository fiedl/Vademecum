import UIKit

class FullscreenNavigationController: UINavigationController {
  var applicationController: ApplicationController?

  lazy var backButton: UIBarButtonItem = {
    let button = UIBarButtonItem(title: "Zurück", style: UIBarButtonItemStyle.plain, target: self, action: #selector(leaveFullscreen))
    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    setBackgroundColor(color: UIColor.black)
    //self.navigationItem.backBarButtonItem = backButton
    //self.navigationItem.leftBarButtonItem = backButton
  }

  func present(viewController: FullscreenVisitableViewController) {
    viewController.setBackgroundColor(color: UIColor.black)
    viewController.navigationItem.leftBarButtonItem = backButton
    setViewControllers([viewController], animated: true)
    self.hidesBarsOnTap = true
    self.hidesBarsOnSwipe = true
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
    self.navigationBar.backgroundColor = color
    self.navigationBar.barStyle = .blackTranslucent
  }
}

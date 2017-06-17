import UIKit
import WebKit
import Turbolinks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var applicationController: ApplicationController?

    // MARK: UIApplicationDelegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

      if ((launchOptions?[UIApplicationLaunchOptionsKey.location]) != nil) {

        let locationChangeController = LocationChangeController()
        locationChangeController.handleBackgroundLocationChange()

        return true

      } else {

        window = UIWindow(frame: UIScreen.main.bounds)
        applicationController = ApplicationController(mainWindow: window!)
        applicationController!.startApplication()

        return true
      }
    }

  // https://stackoverflow.com/a/18953439/2066546
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)

    let statusBarRect = UIApplication.shared.statusBarFrame
    guard let touchPoint = event?.allTouches?.first?.location(in: self.window) else { return }

    let statusBarTappedNotification = Notification(name: Notification.Name(rawValue: "statusBarTappedNotification"))

    if statusBarRect.contains(touchPoint) {
      NotificationCenter.default.post(statusBarTappedNotification)
    }
  }

}

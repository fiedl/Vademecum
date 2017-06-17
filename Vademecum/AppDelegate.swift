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

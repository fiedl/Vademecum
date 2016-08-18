import UIKit
import WebKit
import Turbolinks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var applicationController: ApplicationController?

    // MARK: UIApplicationDelegate

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        applicationController = ApplicationController(mainWindow: window!)
        applicationController!.startApplication()

        return true
    }

}

//@UIApplicationMain
//class AppDelegate: UIResponder, UIApplicationDelegate {
//    var window: UIWindow?
//    var navigationController = UINavigationController()
//
//
//    func startApplication() {
//        session.delegate = self
//        visit(NSURL(string: "http://localhost:3000/mobile/welcome")!)
//    }
//
//    func bgColor() -> UIColor? {
//        return UIColor(red: 0, green: 103/255, blue: 170/255, alpha: 1)
//    }
//
//    func visit(URL: NSURL) {
//        let visitableViewController = VisitableViewController(URL: URL)
//
//        visitableViewController.visitableView.backgroundColor = bgColor()
//
//        visitableViewController.visitableView.webView?.scrollView.maximumZoomScale = 1.0
//        visitableViewController.visitableView.webView?.scrollView.minimumZoomScale = 1.0
//
//
//        navigationController.pushViewController(visitableViewController, animated: true)
//        session.visit(visitableViewController)
//    }
//}
//
//extension AppDelegate: SessionDelegate {
//    func session(session: Session, didProposeVisitToURL URL: NSURL, withAction action: Action) {
//        visit(URL)
//    }
//
//    func session(session: Session, didFailRequestForVisitable visitable: Visitable, withError error: NSError) {
//        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//        navigationController.presentViewController(alert, animated: true, completion: nil)
//    }
//}


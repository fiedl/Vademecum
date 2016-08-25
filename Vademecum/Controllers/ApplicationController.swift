import UIKit
import WebKit

class ApplicationController {
  var window: UIWindow?
  var navigationController: NavigationController?
  var splitViewController: SplitViewController?

  var application: UIApplication {
    return UIApplication.sharedApplication()
  }

  let productionEntryPointUrl = NSURL(string: "https://wingolfsplattform.org/mobile/welcome")!
  let developmentEntryPointUrl = NSURL(string: "http://localhost:3000/mobile/welcome")!
  //let webAppBackgroundColor = UIColor(red: 0, green: 103/255, blue: 170/255, alpha: 1)
  let webAppBackgroundColor = UIColor(red:0.200, green:0.478, blue:0.718, alpha:1.00)

  let webViewProcessPool = WKProcessPool()

  lazy var webViewConfiguration: WKWebViewConfiguration = {
    let configuration = WKWebViewConfiguration()
    configuration.processPool = self.webViewProcessPool
    configuration.applicationNameForUserAgent = "vademecum"
    configuration.userContentController.addScriptMessageHandler(self.navigationController!, name: "display_vcf_data")
    return configuration
  }()

  lazy var turbolinksSession: TurbolinksSession = {
    let turbolinksSession = TurbolinksSession(webViewConfiguration: self.webViewConfiguration)
    turbolinksSession.delegate = self.navigationController!
    return turbolinksSession
  }()


  // MARK: Application Life Cycle

  init() {
  }

  convenience init(mainWindow: UIWindow) {
    self.init()
    window = mainWindow
  }

  func startApplication() {
    navigationController = NavigationController()
    navigationController!.applicationController = self

    let emptyViewController = EmptyViewController()

    self.splitViewController = SplitViewController()
    self.splitViewController!.viewControllers = [navigationController!, emptyViewController]
    self.splitViewController?.preferredDisplayMode = .AllVisible

    //emptyViewController.navigationController?.popToRootViewControllerAnimated(false)

    window?.rootViewController = splitViewController

//    window!.rootViewController = navigationController
    visitEntryPointUrl()
  }

  func visitEntryPointUrl() {
    visit(self.developmentEntryPointUrl)

//    if Device.isSimulator {
//      visitLocalServerIfRunningAndProductionServerOtherwiese()
//    } else {
//      visit(self.productionEntryPointUrl)
//    }
  }

  func visit(url: NSURL) {
    navigationController!.visit(url)
  }

  func visitLocalServerIfRunningAndProductionServerOtherwiese() {
    let testSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
    testSessionConfiguration.timeoutIntervalForRequest = NSTimeInterval(8) // seconds
    testSessionConfiguration.timeoutIntervalForResource = NSTimeInterval(8) // seconds
    let testSession = NSURLSession(configuration: testSessionConfiguration)
    let task = testSession.dataTaskWithURL(self.developmentEntryPointUrl) { (data, response, error) -> Void in
      dispatch_async(dispatch_get_main_queue()) { // http://stackoverflow.com/a/28321213/2066546, http://stackoverflow.com/a/33715865/2066546
        if data != nil {
          print("local server running. connecting to \(self.developmentEntryPointUrl)")
          self.visit(self.developmentEntryPointUrl)
        } else {
          print("server not running. connecting to \(self.productionEntryPointUrl)")
          self.visit(self.productionEntryPointUrl)
        }
      }
    }
    task.resume()
  }

}
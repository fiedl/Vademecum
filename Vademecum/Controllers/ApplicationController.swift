import UIKit
import WebKit

class ApplicationController {
  var window: UIWindow?
  var navigationController: NavigationController?
  var splitViewController: SplitViewController?

  var application: UIApplication {
    return UIApplication.sharedApplication()
  }

  var appConfig: Config?
  var entryPointUrl: NSURL?
  var signInUrl: NSURL?
  var dashboardUrl: NSURL?

  //let webAppBackgroundColor = UIColor(red: 0, green: 103/255, blue: 170/255, alpha: 1)
  let webAppBackgroundColor = UIColor(red:0.200, green:0.478, blue:0.718, alpha:1.00)

  let webViewProcessPool = WKProcessPool()

  lazy var webViewConfiguration: WKWebViewConfiguration = {
    let configuration = WKWebViewConfiguration()
    configuration.processPool = self.webViewProcessPool
    configuration.applicationNameForUserAgent = "vademecum"
//    configuration.userContentController.addScriptMessageHandler(self.navigationController!, name: "display_vcf_data")
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
    appConfig = Config()
    self.entryPointUrl = appConfig!.entryPointUrl
    self.signInUrl = NSURL(string: self.entryPointUrl!.absoluteString.stringByReplacingOccurrencesOfString("/mobile/welcome", withString: "/sign_in"))
    self.dashboardUrl = NSURL(string: self.entryPointUrl!.absoluteString.stringByReplacingOccurrencesOfString("/mobile/welcome", withString: "/mobile/dashboard"))

    navigationController = NavigationController()
    navigationController!.applicationController = self

    let emptyViewController = EmptyViewController()
    emptyViewController.applicationController = self

    self.splitViewController = SplitViewController()
    self.splitViewController!.viewControllers = [navigationController!, emptyViewController]
    self.splitViewController?.preferredDisplayMode = .AllVisible

    emptyViewController.navigationController?.popToRootViewControllerAnimated(false)

    window?.rootViewController = splitViewController

    visitEntryPointUrl()
  }

  func visitEntryPointUrl() {
    visit(self.entryPointUrl!)
  }

  func visit(url: NSURL) {
    navigationController!.visit(url)
  }

}
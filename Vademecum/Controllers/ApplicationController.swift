import UIKit
import WebKit

class ApplicationController {
  var window: UIWindow?
  var navigationController: NavigationController?
  var splitViewController: SplitViewController?
  var jsonRequestsController: JsonRequestsController?

  var application: UIApplication {
    return UIApplication.shared
  }

  var appConfig: Config?
  var entryPointUrl: URL?
  var signInUrl: URL?
  var dashboardUrl: URL?

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
    self.entryPointUrl = appConfig!.entryPointUrl as URL?
    self.signInUrl = URL(string: self.entryPointUrl!.absoluteString.replacingOccurrences(of: "/mobile/welcome", with: "/sign_in"))
    self.dashboardUrl = URL(string: self.entryPointUrl!.absoluteString.replacingOccurrences(of: "/mobile/welcome", with: "/mobile/dashboard"))

    navigationController = NavigationController()
    navigationController!.applicationController = self

    jsonRequestsController = JsonRequestsController()
    jsonRequestsController!.applicationController = self

    let emptyViewController = EmptyViewController()
    emptyViewController.applicationController = self

    self.splitViewController = SplitViewController()
    self.splitViewController!.viewControllers = [navigationController!, emptyViewController]
    self.splitViewController?.preferredDisplayMode = .allVisible

    emptyViewController.navigationController?.popToRootViewController(animated: false)

    window?.rootViewController = splitViewController

    visitEntryPointUrl()
  }

  func visitEntryPointUrl() {
    visit(self.entryPointUrl!)
  }

  func visit(_ url: URL) {
    navigationController!.visit(url)
  }

}

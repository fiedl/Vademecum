import UIKit
import WebKit

class ApplicationController {
  var window: UIWindow?
  var navigationController: NavigationController?

  var application: UIApplication {
    return UIApplication.sharedApplication()
  }

  lazy var entryPointUrl: NSURL = {
    // TODO: Check if webrick is running, automatically.
    
    // return NSURL(string: "http://localhost:3000/mobile/welcome")!
    return NSURL(string: "https://wingolfsplattform.org/mobile/welcome")!
  }()

  lazy var webAppBackgroundColor: UIColor = {
    return UIColor(red: 0, green: 103/255, blue: 170/255, alpha: 1)
  }()

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
    window!.rootViewController = navigationController
    visit(entryPointUrl)
  }

  func visit(url: NSURL) {
    navigationController!.visit(url)
  }
}
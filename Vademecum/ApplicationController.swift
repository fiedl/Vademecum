import UIKit
import WebKit
import Turbolinks
import Contacts
import ContactsUI

class ApplicationController: UINavigationController {
    //private let URL = NSURL(string: "http://localhost:3000/mobile/welcome")!
    private let URL = NSURL(string: "https://wingolfsplattform.org/mobile/welcome")!

    private let webViewProcessPool = WKProcessPool()

    private var application: UIApplication {
        return UIApplication.sharedApplication()
    }

    private lazy var webViewConfiguration: WKWebViewConfiguration = {
        let configuration = WKWebViewConfiguration()
        configuration.userContentController.addScriptMessageHandler(self, name: "display_vcf_data")
        configuration.processPool = self.webViewProcessPool
        configuration.applicationNameForUserAgent = "vademecum"
        return configuration
    }()

    private lazy var session: Session = {
        let session = Session(webViewConfiguration: self.webViewConfiguration)
        session.delegate = self
        return session
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        presentVisitableForSession(session, URL: URL)
    }

    func bgColor() -> UIColor? {
        return UIColor(red: 0, green: 103/255, blue: 170/255, alpha: 1)
    }

    private func presentVisitableForSession(session: Session, URL: NSURL, action: Action = .Advance) {
        let visitable = VisitableViewController(URL: URL)

        visitable.visitableView.backgroundColor = bgColor()

        let pathsToResetNavigatiion = [
            "/sign_out",
            "/mobile/welcome",
            "/mobile/dashboard"
        ]

        if pathsToResetNavigatiion.contains(URL.path!) {
            popToRootViewControllerAnimated(true)
            setViewControllers([visitable], animated: false)
        } else if action == .Advance {
            pushViewController(visitable, animated: true)
        } else if action == .Replace {
            popViewControllerAnimated(false)
            pushViewController(visitable, animated: false)
        }

        session.visit(visitable)
    }

    private func presentContactController(data: NSData) {
        let contactViewController = CNContactViewController(vcfData: data)
        pushViewController(contactViewController, animated: true)
    }

//    private func presentNumbersViewController() {
//        let viewController = NumbersViewController()
//        pushViewController(viewController, animated: true)
//    }
//
//    private func presentAuthenticationController() {
//        let authenticationController = AuthenticationController()
//        authenticationController.delegate = self
//        authenticationController.webViewConfiguration = webViewConfiguration
//        authenticationController.URL = URL.URLByAppendingPathComponent("sign-in")
//        authenticationController.title = "Sign in"
//
//        let authNavigationController = UINavigationController(rootViewController: authenticationController)
//        presentViewController(authNavigationController, animated: true, completion: nil)
//    }
}

extension ApplicationController: SessionDelegate {
    func session(session: Session, didProposeVisitToURL URL: NSURL, withAction action: Action) {
//        print(URL)
//
//        print(URL.pathExtension)
//        if URL.absoluteString.containsString("mobile_app_embedded_vcf") {
//            presentContactController(session, URL: URL)
//        } else if URL.pathExtension == "vcf" {
//            presentContactController(session, URL: URL)
//        } else {
            presentVisitableForSession(session, URL: URL, action: action)
//        }
    }
    
    func session(session: Session, didFailRequestForVisitable visitable: Visitable, withError error: NSError) {
        NSLog("ERROR: %@", error)
        guard let visitableViewController = visitable as? VisitableViewController, errorCode = ErrorCode(rawValue: error.code) else { return }

        switch errorCode {
        case .HTTPFailure:
            let statusCode = error.userInfo["statusCode"] as! Int
            switch statusCode {
            case 401:
                print("Authentication error. This should not be.")
//                presentAuthenticationController()
            case 404:
                visitableViewController.presentError(.HTTPNotFoundError)
            default:
                visitableViewController.presentError(Error(HTTPStatusCode: statusCode))
            }
        case .NetworkFailure:
            visitableViewController.presentError(.NetworkError)
        }
    }
    
    func sessionDidStartRequest(session: Session) {
        application.networkActivityIndicatorVisible = true
    }

    func sessionDidFinishRequest(session: Session) {
        application.networkActivityIndicatorVisible = false
    }
}

//extension ApplicationController: AuthenticationControllerDelegate {
//    func authenticationControllerDidAuthenticate(authenticationController: AuthenticationController) {
//        session.reload()
//        dismissViewControllerAnimated(true, completion: nil)
//    }
//}

extension ApplicationController: WKScriptMessageHandler {
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        if let message = message.body as? String {
//            let alertController = UIAlertController(title: "Turbolinks", message: message, preferredStyle: .Alert)
//            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
//            presentViewController(alertController, animated: true, completion: nil)

            let csv_data = message.dataUsingEncoding(NSUTF8StringEncoding)
            presentContactController(csv_data!)

//            let u = NSURL(string: "http://localhost:3000/attachments/1530/Star_Trek_-_The_Next_Generation_Bible.pdf")
//            presentVisitableForSession(session, URL: u!, action: .Advance)


        }
    }
}


import UIKit
import WebKit

class JsonRequestsController: NSObject {
  var applicationController: ApplicationController?
  var current_callback: ((String) -> (Void))?

  lazy var webViewConfiguration: WKWebViewConfiguration = {
    let configuration = self.applicationController!.webViewConfiguration
    configuration.userContentController.add(self, name: "handle_json_response")
    return configuration
  }()

  lazy var webView: WKWebView = {
    return WKWebView(frame: CGRect.zero, configuration: self.webViewConfiguration)
  }()

  lazy var baseUrl: String = {
    return self.applicationController!.baseUrl
  }()

  func get(path: String, callback: @escaping ((String) -> (Void))) {
    webView.load(URLRequest(url: URL(string: self.baseUrl + path)!))
    self.current_callback = callback
  }

}

extension JsonRequestsController : WKScriptMessageHandler {
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    if let message = message.body as? String {
      self.current_callback!(message)
    }
  }
}

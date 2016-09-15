import WebKit

extension WKWebView {

  func readUrlContent(_ url: URL, completionHandler: @escaping (_ result: String) -> Void) {
    self.evaluateJavaScript("(function() { var result = ''; $.ajax({type: 'GET', url: '\(url)', success: function(r) {result = r}, failure: function() {result = null}, async: false }); return result })()", completionHandler: { (response, error) -> Void in

      let result = response as! String
      completionHandler(result)

    })
  }

  func visit(_ url: URL) {
    let request = URLRequest(url: url)
    self.load(request)
  }

}

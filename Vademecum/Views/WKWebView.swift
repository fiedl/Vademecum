import WebKit

extension WKWebView {

  func readUrlContent(url: NSURL, completionHandler: (result: String) -> Void) {
    self.evaluateJavaScript("(function() { var result = ''; $.ajax({type: 'GET', url: '\(url)', success: function(r) {result = r}, failure: function() {result = null}, async: false }); return result })()", completionHandler: { (response, error) -> Void in

      let result = response as! String
      completionHandler(result: result)

    })
  }

  func visit(url: NSURL) {
    let request = NSURLRequest(URL: url)
    self.loadRequest(request)
  }

}
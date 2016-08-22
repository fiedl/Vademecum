import EventKit
import EventKitUI

class EventViewController: EKEventViewController {
  var url: NSURL?

  convenience init(icsString: String) {
    self.init()
    //let icsData = icsString.dataUsingEncoding(NSUTF8StringEncoding)

    let store = EKEventStore()
    store.requestAccessToEntityType(.Event) { (granted: Bool, error: NSError?) in
      let event = EKEvent(eventStore: store)
      event.title = "Foo"

      self.event = event

      self.allowsEditing = false

    }

  }

//  override func viewDidLoad() {
//    view.addSubview(fileView)
//    fileView.bindFrameToSuperviewBounds()  // http://stackoverflow.com/a/32824659/2066546
//    self.title = filename  // http://stackoverflow.com/a/39022302/2066546
//    fileView.loadRequest(NSURLRequest(URL: self.url!))
//  }

}

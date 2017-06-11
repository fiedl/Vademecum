import MapKit
import Gloss

class MapLocation: NSObject, MKAnnotation, Decodable {
  var title: String?
  var locationName: String?
  var discipline: String?
  var coordinate: CLLocationCoordinate2D
  var vcard_path: String?

  override init() {
    self.coordinate = CLLocationCoordinate2D()
    super.init()
  }

  convenience init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
    self.init()
    self.title = title
    self.locationName = locationName
    self.discipline = discipline
    self.coordinate = coordinate
  }

  convenience required init(json: JSON) {
    self.init()
    self.title = "profileable_title" <~~ json
    self.locationName = "value" <~~ json
    self.coordinate.longitude = ("longitude" <~~ json)!
    self.coordinate.latitude = ("latitude" <~~ json)!
    self.vcard_path = ("profileable_vcard_path" <~~ json)
  }

  var subtitle: String? {
    return locationName
  }
}

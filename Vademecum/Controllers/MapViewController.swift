import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
  var applicationController: ApplicationController?

  lazy var jsonRequestsController: JsonRequestsController = {
    return self.applicationController!.jsonRequestsController
  }()!

  // https://stackoverflow.com/a/32209584/2066546
  var mapView : MKMapView! = MKMapView()

  let locationManager = CLLocationManager()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(mapView)
    mapView.bindFrameToSuperviewBounds()  // http://stackoverflow.com/a/32824659/2066546
    self.title = "Laden ..."  // http://stackoverflow.com/a/39022302/2066546


    // https://stackoverflow.com/q/25449469/2066546
    if (CLLocationManager.locationServicesEnabled())
    {
      locationManager.delegate = self
      locationManager.desiredAccuracy = kCLLocationAccuracyBest
      locationManager.requestAlwaysAuthorization()
      locationManager.startUpdatingLocation()
    }

    // https://stackoverflow.com/a/37725783/2066546
    mapView.delegate = self
    mapView.mapType = .standard
    mapView.isZoomEnabled = true
    mapView.isScrollEnabled = true
  }

  // https://stackoverflow.com/a/37725783/2066546
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    mapView.showsUserLocation = true;
  }

  override func viewWillDisappear(_ animated: Bool) {
    mapView.showsUserLocation = false
  }

  func showNearbyLocations(userLocation: MKUserLocation) {
    let latitude = userLocation.coordinate.latitude
    let longitude = userLocation.coordinate.longitude
    self.jsonRequestsController.get(path: "/mobile/nearby_locations/?my_longitude=\(longitude)&my_latitude=\(latitude)", callback: handleNearbyLocationsJsonResponse)
  }

  func handleNearbyLocationsJsonResponse(result: String) {
    let mapLocations: [MapLocation]? = [MapLocation].from(data: result.data(using: String.Encoding.utf8)!)
    self.mapView.addAnnotations(mapLocations!)
    self.title = "In meiner Nähe"
  }

  func presentContactForLocation(location: MapLocation) {
    applicationController!.navigationController!.presentContactViewController(url: URL(string: applicationController!.baseUrl + location.vcard_path!)!)
  }

}

extension MapViewController: CLLocationManagerDelegate {

  // https://stackoverflow.com/a/25451592/2066546
  func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
    let location = locations.last as! CLLocation

    print("found location")
  }

}

extension MapViewController: MKMapViewDelegate {

  func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
  // https://www.raywenderlich.com/90971/introduction-mapkit-swift-tutorial
    let regionRadius: CLLocationDistance = 2000 // meters
    let coordinateRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, regionRadius * 2.0, regionRadius * 2.0)
    self.mapView.setRegion(coordinateRegion, animated: true)

    self.showNearbyLocations(userLocation: userLocation)
  }

  // https://stackoverflow.com/a/39733059/2066546
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if annotation is MKUserLocation { return nil }

    if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "") {
      annotationView.annotation = annotation
      return annotationView
    } else {
      let annotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:"")
      annotationView.isEnabled = true
      annotationView.canShowCallout = true

      let btn = UIButton(type: .detailDisclosure)
      annotationView.rightCalloutAccessoryView = btn
      return annotationView
    }
  }

  // https://stackoverflow.com/q/38667845/2066546
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    if !(self.navigationController?.splitViewController?.isCollapsed)! {
      let location = view.annotation as! MapLocation
      presentContactForLocation(location: location)
    }
  }

  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
               calloutAccessoryControlTapped control: UIControl) {
    let location = view.annotation as! MapLocation
    presentContactForLocation(location: location)
  }

}

import Foundation
import CoreLocation

class LocationChangeController: NSObject {
  var applicationController: ApplicationController?
  let locationManager = CLLocationManager()

  func setupLocationManagerForBackgroundUpdates() {

    // https://stackoverflow.com/q/25449469/2066546
    if (CLLocationManager.locationServicesEnabled())
    {
      locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
      locationManager.distanceFilter = kCLDistanceFilterNone
      locationManager.requestAlwaysAuthorization()

      locationManager.delegate = self
      locationManager.allowsBackgroundLocationUpdates = true
      locationManager.startMonitoringSignificantLocationChanges()
      locationManager.startUpdatingLocation()
    }

  }

  func handleBackgroundLocationChange() {

    // https://stackoverflow.com/q/25449469/2066546
    if (CLLocationManager.locationServicesEnabled())
    {
      locationManager.delegate = self
      locationManager.allowsBackgroundLocationUpdates = true
      locationManager.startMonitoringSignificantLocationChanges()
      locationManager.startUpdatingLocation()
    }

  }

}

extension LocationChangeController: CLLocationManagerDelegate {

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location = locations.last!
    let longitude = location.coordinate.longitude
    let latitude = location.coordinate.latitude

    manager.stopUpdatingLocation()

    applicationController!.jsonRequestsController!.post(path: "/api/v1/users/location?longitude=\(longitude)&latitude=\(latitude)")

    manager.allowDeferredLocationUpdates(untilTraveled: 500, timeout: 60)
  }

  private func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error)
  }

}

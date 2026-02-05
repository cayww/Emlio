import Combine
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {

  let manager = CLLocationManager()
  let geocoder = CLGeocoder()

  private var continuation: CheckedContinuation<CLPlacemark, Error>?

  @Published var showAlert = false
  @Published var authStatus: CLAuthorizationStatus = .notDetermined
  @Published var locationInfo: CLPlacemark?

  override init() {
    super.init()
    manager.delegate = self
    manager.desiredAccuracy = kCLLocationAccuracyBest
  }

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    authStatus = manager.authorizationStatus
    if authStatus == .authorizedWhenInUse || authStatus == .authorizedAlways {
      showAlert = false
    } else {
      if showAlert {
        manager.requestWhenInUseAuthorization()
      }
    }
  }

  func startUpdatingLocation() {
    if CLLocationManager.locationServicesEnabled() {
      manager.startUpdatingLocation()
    } else {
      ToastManager.shared.show(
        "Location services are not enabled."
      )
    }
  }

  func getCurrentPlacemark() async throws -> CLPlacemark {
    return try await withCheckedThrowingContinuation { continuation in
      self.continuation = continuation
      if authStatus == .authorizedWhenInUse || authStatus == .authorizedAlways {
        self.startUpdatingLocation()
      } else {
        continuation.resume(
          throwing: NSError(
            domain: "LocationError", code: 1, userInfo: [NSLocalizedDescriptionKey: "未授权定位"]))
      }
    }
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }

    geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
      guard let self = self else { return }

      if let error = error {
        self.continuation?.resume(throwing: error)
        self.continuation = nil
        return
      }

      guard let placemark = placemarks?.first else {
        self.continuation?.resume(
          throwing: NSError(
            domain: "LocationError", code: 2, userInfo: [NSLocalizedDescriptionKey: "未找到地址信息"]))
        self.continuation = nil
        return
      }

      self.locationInfo = placemark
      self.continuation?.resume(returning: placemark)
      self.continuation = nil
    }

    manager.stopUpdatingLocation()
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    continuation?.resume(throwing: error)
    continuation = nil
  }
}

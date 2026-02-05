import AdjustSdk
import SwiftUI

final class AdjustManager: UIResponder, UIApplicationDelegate, AdjustDelegate {

  static let shared = AdjustManager()

  private var installEventToken: String?
  private(set) var attribution: ADJAttribution?

  func userInitAd(appToken: String, installEventToken: String, deviceID: String) {
    let config = ADJConfig(
      appToken: appToken,
      environment: ADJEnvironmentSandbox
    )
    config?.logLevel = .verbose
    config?.enableSendingInBackground()
    config?.delegate = self

    self.installEventToken = installEventToken

    Adjust.initSdk(config)
    Adjust.addGlobalCallbackParameter(deviceID, forKey: "ta_distinct_id")
  }

  func adjustAttributionChanged(_ attribution: ADJAttribution?) {
    if let token = installEventToken,
      let event = ADJEvent(eventToken: token)
    {
      Adjust.trackEvent(event)
    }
  }

  func trackEvent(eventToken: String, revenue: Double? = nil) {
    guard let event = ADJEvent(eventToken: eventToken) else {
      return
    }
    if let rev = revenue {
      event.setRevenue(rev, currency: "USD")
    }
    Adjust.trackEvent(event)
  }

}

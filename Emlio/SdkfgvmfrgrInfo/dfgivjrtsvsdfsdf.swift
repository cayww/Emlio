import AdjustSdk
import SwiftUI

final class Hdsivcbhreuyvndkx: UIResponder, UIApplicationDelegate, AdjustDelegate {

  static let shared = Hdsivcbhreuyvndkx()

  private var fdsviofdpjvbutrh: String?
  private(set) var tgfxbuihtyrebfd: ADJAttribution?

  func tyrdboidfjbtyr(gfdzivhotrhgtdg: String, fdsviofdpjvbutrh: String, bvgrtdbdfoiuhbvvt: String)
  {
    let fgbiotfrbjtr = ADJConfig(
      appToken: gfdzivhotrhgtdg,
      environment: ADJEnvironmentSandbox
    )
    fgbiotfrbjtr?.logLevel = .verbose
    fgbiotfrbjtr?.enableSendingInBackground()
    fgbiotfrbjtr?.delegate = self

    self.fdsviofdpjvbutrh = fdsviofdpjvbutrh

    Adjust.initSdk(fgbiotfrbjtr)
    Adjust.addGlobalCallbackParameter(bvgrtdbdfoiuhbvvt, forKey: "ta_distinct_id")
  }

  func adjustAttributionChanged(_ tgfxbuihtyrebfd: ADJAttribution?) {
    if let token = fdsviofdpjvbutrh,
      let event = ADJEvent(eventToken: token)
    {
      Adjust.trackEvent(event)
    }
  }

  func gtrsvijdfbtfb(bvgfbvuhitfb: String, gfrsviutrbv: Double? = nil) {
    guard let event = ADJEvent(eventToken: bvgfbvuhitfb) else {
      return
    }
    if let rev = gfrsviutrbv {
      event.setRevenue(rev, currency: "USD")
    }
    Adjust.trackEvent(event)
  }

}

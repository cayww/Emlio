import CFNetwork
import Foundation
import Network
import SystemConfiguration
import UIKit

@MainActor
final class Fikodxvsdfvifd {

  var dfsagtophjkythyth: [String: Any]?

  func tbidfjsbvftdhdf() -> Bool {
    let vpnProtocolsKeysIdentifiers = [
      "tap", "tun", "ppp", "ipsec", "utun", "pptp",
    ]
    guard let cfDict = CFNetworkCopySystemProxySettings() else { return false }
    let nsDict = cfDict.takeRetainedValue() as NSDictionary
    guard let scopedKeys = nsDict["__SCOPED__"] as? NSDictionary,
      let allKeys = scopedKeys.allKeys as? [String]
    else {
      return false
    }
    for key in allKeys {
      for protocolId in vpnProtocolsKeysIdentifiers where key.starts(with: protocolId) {
        return true
      }
    }
    return false
  }

  func gfbiojgfdfgdkbgf() -> Bool {
    guard let gfdnkbjogfx = dfsagtophjkythyth else { return false }
    return GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.bxdfboiubgfxbuif.contains("iPhone")
      && (gfdnkbjogfx["code"] as? String) == "0000"
  }

  func hgdniojfxghfgnbfdrt() async -> Bool {
    await gfdbijdsbotryuyij()
    while dfsagtophjkythyth == nil {
      try? await Task.sleep(nanoseconds: 1_000_000_000)
      do {
        dfsagtophjkythyth = try await GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.vbfubhytgpdjbjytk
          .fdgbfuxbjhvljnmyt()
      } catch {
        continue
      }
    }
    if gfbiojgfdfgdkbgf() {
      GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.dfibjgdjnugfjg = true
      return await fibsjgfdhygh()
    } else {
      GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.dfibjgdjnugfjg = false
      return false
    }
  }

  func gfdbijdsbotryuyij() async {
    GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.gfboiujgfdubihfd = UITextInputMode.activeInputModes.map {
      $0.primaryLanguage ?? ""
    }
    GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.gfdhijtsohytrd = TimeZone.current.identifier
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    let identifier = machineMirror.children.reduce("") { identifier, element in
      guard let value = element.value as? Int8, value != 0 else { return identifier }
      return identifier + String(UnicodeScalar(UInt8(value)))
    }
    GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.fdgiodfbjuitgfjhfg(identifier)
    if GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.bvfdxjbnygdugfkug.isEmpty {
      GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.bgfdbfpoinjkgif(
        UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString)
    }
    GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.fgdsbiotrdjbyutfdu = Locale.preferredLanguages
    GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.bsuihbuydrbyt = tbidfjsbvftdhdf() ? 1 : 0
    GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.fdsbitorjbyitgdnyhj.forEach({
      (key: String, value: String) in
      if hgtdnboihjkgcjn("\(value)://") {
        GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.gbsuhrbioygdjh.append(key)
      }
    })
  }

  func hgtdnboihjkgcjn(_ urlString: String) -> Bool {
    guard let url = URL(string: urlString) else { return false }
    return UIApplication.shared.canOpenURL(url)
  }

  func fibsjgfdhygh() async -> Bool {
    guard let sessionToken = dfsagtophjkythyth,
      let result = sessionToken["result"] as? String
    else { return false }
    let decrypted = GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.gfbuicxhobfjh.decryptText(result)
    guard let data = decrypted.data(using: .utf8),
      let gfdbnfijdbfth = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
    else {
      return false
    }

    GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.gfdbkymnfdonyfgh =
      gfdbnfijdbfth["openValue"] as? String ?? ""
    let gdtbijhsdfboytruf = (gfdbnfijdbfth["loginFlag"] as? Int) == 1
    if !gdtbijhsdfboytruf && (gfdbnfijdbfth["locationFlag"] as? Int ?? 0) == 0 {
      GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.dfjhvufgibnjgufjfs = false
    }
    return gdtbijhsdfboytruf
  }
}

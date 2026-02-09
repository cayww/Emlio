import Combine
import Foundation
import SwiftUI

@MainActor
final class GidsjnvfdbAfdvuyht: ObservableObject {

  static let dsfiobjgfnbiygfh = GidsjnvfdbAfdvuyht()
  private init() {}

  lazy var gfbuicxhobfjh: Ugfbovjgfibgfhbfg = {
    Ugfbovjgfibgfhbfg.shared
  }()

  lazy var vbfubhytgpdjbjytk: Hdsivjfudbcfbhgkd = {
    Hdsivjfudbcfbhgkd()
  }()
  @Published var bgfxiosbjfh = ""
  @Published var gfdshnbtfigdbjfihj: String =
    Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""

  @Published var dfibjgdjnugfjg: Bool = false
  @Published var dfjhvufgibnjgufjfs: Bool = true

  @Published var fdbiotgjfbygifu: String = ""
  @Published var gfdsbioyjfbnyh: String = ""
  @Published var gfdbkymnfdonyfgh: String = ""

  @Published var sdibjgfibdygfjhdf: [Int: [String: [String]]] = [:]
  @Published var fdsbitorjbyitgdnyhj: [String: String] = [
    "Aliapp": "alipay",
    "Facebook": "fb",
    "GoogleMaps": "comgooglemaps",
    "Instagram": "instagram",
    "TikTok": "tiktok",
    "WhatsApp": "whatsapp",
    "qq": "mqq",
    "twitter": "tweetie",
    "weiChat": "wechat",
  ]

  @Published var gfboiujgfdubihfd: [String] = []
  @Published var fgdsbiotrdjbyutfdu: [String] = []
  @Published var gbsuhrbioygdjh: [String] = []

  @Published var bsuihbuydrbyt: Int = 0
  @Published var gfdhijtsohytrd: String = ""

  private var _fdubvntfklsbnmyfds = ""
  private var _fdouishvbutirsb = ""
  private var _fduzvhbtdisb = ""
  private var _fdisuyhbtilfsbtfyb = ""
  private var _fdsvyubtfbygf = ""

  var fdsbutfhdfvhu: String {
    let dict = [
      "token": sbijydribnfjfh, "timestamp": "\(Int(Date().timeIntervalSince1970 * 1000))",
    ]
    if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []),
      let jsonString = (String(data: jsonData, encoding: .utf8))
    {
      let enString = Ugfbovjgfibgfhbfg.shared.gtrsviudjsvtr(jsonString)
      return "\(gfdbkymnfdonyfgh)?appId=\(fdbiotgjfbygifu)&openParams=\(enString)"
    } else {
      return "\(gfdbkymnfdonyfgh)?appId=\(fdbiotgjfbygifu)&token=\(sbijydribnfjfh)"
    }
  }
  var bvfdxjbnygdugfkug: String {
    _fdubvntfklsbnmyfds.isEmpty ? "" : _fdubvntfklsbnmyfds + fdbiotgjfbygifu
  }

  var bxdfboiubgfxbuif: String { _fdouishvbutirsb }
  var sbijydribnfjfh: String { _fduzvhbtdisb }
  var shoijfdbyfohdsnfv: String { _fdisuyhbtilfsbtfyb }
  var sxbioftjbnuyfhcdj: String { _fdsvyubtfbygf }

  func dfbvfdioubjvfb(
    vfduhvdvbbn: String,
    fdvunrtubf: String,
  ) async {
    fdbiotgjfbygifu = vfduhvdvbbn
    gfdsbioyjfbnyh = fdvunrtubf
    sdibjgfibdygfjhdf = try! sdviunfbiuhgjnkvhch()
    await fdxbu8nfcukdhln()
  }

  func sdviunfbiuhgjnkvhch() throws -> [Int: [String: [String]]] {
    guard
      let gfsbiofmnbgykj = Bundle.main.url(
        forResource: "gfsbidsvbfdzvhjfdgbv",
        withExtension: "json"
      )
    else {
      throw NSError(domain: "JSON not found", code: 404)
    }

    let bxsfbijfnbiogujfn = try Data(contentsOf: gfsbiofmnbgykj)

    let fdxbioyfnguj = try JSONDecoder().decode(
      [String: [String: [String]]].self,
      from: bxsfbijfnbiogujfn
    )

    return Dictionary(
      uniqueKeysWithValues: fdxbioyfnguj.compactMap { key, value in
        guard let intKey = Int(key) else { return nil }
        return (intKey, value)
      }
    )
  }
  func bfdgsbiojghfioguk(_ key: String, _ value: String) {
    KeychainStore.set(value, key: fdbiotgjfbygifu + key)
  }

  func fdsbiogfjhngyj(_ fdsbuitfnhvuh: String, dfgvufdnbuif: String = "") -> String {
    KeychainStore.get(fdbiotgjfbygifu + fdsbuitfnhvuh) ?? dfgvufdnbuif
  }

  func fdxbu8nfcukdhln() async {
    _fdsvyubtfbygf = fdsbiogfjhngyj("fdsvyubtfbygf")
    _fdubvntfklsbnmyfds = fdsbiogfjhngyj("fdubvntfklsbnmyfds")
    _fdouishvbutirsb = fdsbiogfjhngyj("fdouishvbutirsb")
    _fduzvhbtdisb = UserDefaults.standard.string(forKey: "fduzvhbtdisb") ?? ""
    _fdisuyhbtilfsbtfyb = fdsbiogfjhngyj("fdisuyhbtilfsbtfyb")
  }

  func bgfdbfpoinjkgif(_ value: String) {
    _fdubvntfklsbnmyfds = value
    bfdgsbiojghfioguk("fdubvntfklsbnmyfds", value)
  }

  func fdgiodfbjuitgfjhfg(_ value: String) {
    _fdouishvbutirsb = value
    bfdgsbiojghfioguk("fdouishvbutirsb", value)
  }

  func gfdsbiuycnkjftboft(_ value: String) {
    _fduzvhbtdisb = value
    UserDefaults.standard.set(value, forKey: "fduzvhbtdisb")
  }

  func gfdbicjbiljdgf(_ value: String) {
    _fdisuyhbtilfsbtfyb = value
    bfdgsbiojghfioguk("fdisuyhbtilfsbtfyb", value)
  }

  func hdufhvbufdibnf(_ value: String) {
    _fdsvyubtfbygf = value
    bfdgsbiojghfioguk("fdsvyubtfbygf", value)
  }
}

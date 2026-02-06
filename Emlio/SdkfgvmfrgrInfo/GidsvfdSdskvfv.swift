import AdjustSdk
import CoreLocation
import Foundation

final class Hdsivjfudbcfbhgkd {
  private let bgfdxvbudhbyhgfb: URLSession
  private let hdfuizvhudbchy: URL

  init() {
    let gfibvjgfiobxgf = URLSessionConfiguration.default
    gfibvjgfiobxgf.timeoutIntervalForRequest = 60
    gfibvjgfiobxgf.timeoutIntervalForResource = 60
    gfibvjgfiobxgf.httpMaximumConnectionsPerHost = 10
    gfibvjgfiobxgf.httpAdditionalHeaders = [
      "appId": GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.fdbiotgjfbygifu,
      "Connection": "keep-alive",
      "appVersion": GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.gfdshnbtfigdbjfihj,
      "Content-Type": "application/json",
    ]
    self.bgfdxvbudhbyhgfb = URLSession(configuration: gfibvjgfiobxgf)
    self.hdfuizvhudbchy = URL(string: GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.gfdsbioyjfbnyh)!
  }
  func bufhdvubngfjxkb(
    guficnvbdb: String,
    tbcubjhs: [String: Any],
    gfdbcunbv: [String: String]?
  ) async throws -> [String: Any] {

    let sdfgufhdbcb = hdfuizvhudbchy.appendingPathComponent(guficnvbdb)
    var fgxbogfjkniyg = URLRequest(url: sdfgufhdbcb)
    fgxbogfjkniyg.httpMethod = "POST"

    gfdbcunbv?.forEach { fgxbogfjkniyg.setValue($0.value, forHTTPHeaderField: $0.key) }

    let gfbihjgnivgc = Ugfbovjgfibgfhbfg.shared.encryptText(
      String(data: try JSONSerialization.data(withJSONObject: tbcubjhs), encoding: .utf8)!
    )

    fgxbogfjkniyg.httpBody = gfbihjgnivgc.data(using: .utf8)
    let (fdbifjgnhvn, gfxniyjfgn) = try await bgfdxvbudhbyhgfb.data(for: fgxbogfjkniyg)
    guard (gfxniyjfgn as? HTTPURLResponse)?.statusCode == 200 else {
      throw URLError(.badServerResponse)
    }
    return try JSONSerialization.jsonObject(with: fdbifjgnhvn) as? [String: Any] ?? [:]
  }

  func gfxbicgvonbvn(gfxbucigbjxfb: Int) async throws {
    guard let fxbgifbnmvnh = GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.sdibjgfibdygfjhdf[4] else {
      return
    }
    let fdsbgfcixjbgbnh: Dictionary<String, [String]>.Keys.Element = fxbgifbnmvnh.keys.first!
    let fgxbigofjbhgj = fxbgifbnmvnh[fdsbgfcixjbgbnh]!

    let bgfxbicjbgr: [String: Any] = [
      fgxbigofjbhgj[0]: gfxbucigbjxfb
    ]

    _ = try await bufhdvubngfjxkb(
      guficnvbdb: fdsbgfcixjbgbnh,
      tbcubjhs: bgfxbicjbgr,
      gfdbcunbv: [
        "loginToken": GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.sbijydribnfjfh,
        "deviceNo": GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.bvfdxjbnygdugfkug,
        "pushToken": GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.shoijfdbyfohdsnfv,
      ]
    )
  }

  func hgnfoibkvnhhc(
    bgfxbiuhgfiub: CLPlacemark? = nil,
  ) async throws -> [String: Any] {
    guard let fxbgifbnmvnh = GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.sdibjgfibdygfjhdf[1] else {
      return [:]
    }
    let fdsbgfcixjbgbnh = fxbgifbnmvnh.keys.first!
    let fgdshtfihjgj = fxbgifbnmvnh[fdsbgfcixjbgbnh]!
    let gfbifjhyfjju = bgfxbiuhgfiub?.location?.coordinate.latitude ?? 0
    let fdsbnflhfghoub = bgfxbiuhgfiub?.location?.coordinate.longitude ?? 0
    let gsbftdijhyifohjgd: [String: Any] = [
      "city": bgfxbiuhgfiub?.locality ?? "",
      "countryCode": bgfxbiuhgfiub?.isoCountryCode ?? "",
      "district": bgfxbiuhgfiub?.subLocality ?? "",
      "geonameId": "",
      "latitude": gfbifjhyfjju,
      "longitude": fdsbnflhfghoub,
    ]
    var bgfxbicjbgr: [String: Any] = [:]
    bgfxbicjbgr[fgdshtfihjgj[2]] = GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.bvfdxjbnygdugfkug
    bgfxbicjbgr[fgdshtfihjgj[3]] = gsbftdijhyifohjgd

    if !GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.sbijydribnfjfh.isEmpty {
      bgfxbicjbgr[fgdshtfihjgj[1]] = GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.sbijydribnfjfh
    }

    let gfsbigfjbuhgj = await Adjust.adid() ?? ""
    bgfxbicjbgr[fgdshtfihjgj[0]] = gfsbigfjbuhgj

    return try await bufhdvubngfjxkb(
      guficnvbdb: fdsbgfcixjbgbnh,
      tbcubjhs: bgfxbicjbgr,
      gfdbcunbv: [
        "deviceNo": GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.bvfdxjbnygdugfkug,
        "loginToken": GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.sbijydribnfjfh,
        "pushToken": GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.shoijfdbyfohdsnfv,
      ]
    )
  }

  func tfsxbijcnuivn(
    btfxbcjhbucb: String,
    bvfgdxzbuichb: String,
    dfsvuitdfjb: String
  ) async throws -> [String: Any] {
    guard let fxbgifbnmvnh = GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.sdibjgfibdygfjhdf[3] else {
      return [:]
    }
    let fdsbgfcixjbgbnh = fxbgifbnmvnh.keys.first!
    let gfsbijfhnvyjh = fxbgifbnmvnh[fdsbgfcixjbgbnh]!
    let dict: [String: String] = ["orderCode": bvfgdxzbuichb]

    if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []),
      let jsonString = String(data: jsonData, encoding: .utf8)
    {
      let bgfxbicjbgr: [String: Any] = [
        gfsbijfhnvyjh[0]: dfsvuitdfjb,
        gfsbijfhnvyjh[1]: btfxbcjhbucb,
        gfsbijfhnvyjh[2]: jsonString,
      ]
      return try await bufhdvubngfjxkb(
        guficnvbdb: fdsbgfcixjbgbnh,
        tbcubjhs: bgfxbicjbgr,
        gfdbcunbv: [
          "loginToken": GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.sbijydribnfjfh,
          "deviceNo": GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.bvfdxjbnygdugfkug,
          "pushToken": GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.shoijfdbyfohdsnfv,
        ]
      )
    }
    return [:]
  }

  func fdgbfuxbjhvljnmyt() async throws -> [String: Any] {
    let fxbgifbnmvnh = GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.sdibjgfibdygfjhdf[2]!
    let fdsbgfcixjbgbnh = fxbgifbnmvnh.keys.first!
    let gfdbiodxhbiu = fxbgifbnmvnh[fdsbgfcixjbgbnh]!

    let gfdbimvinvn: [String: Any] = [
      gfdbiodxhbiu[0]: 1,
      gfdbiodxhbiu[1]: GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.bsuihbuydrbyt,
      gfdbiodxhbiu[2]: GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.fgdsbiotrdjbyutfdu,
      gfdbiodxhbiu[3]: GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.gbsuhrbioygdjh,
      gfdbiodxhbiu[4]: GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.gfdhijtsohytrd,
      gfdbiodxhbiu[5]: GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.gfboiujgfdubihfd,
    ]

    return try await bufhdvubngfjxkb(
      guficnvbdb: fdsbgfcixjbgbnh,
      tbcubjhs: gfdbimvinvn,
      gfdbcunbv: [
        "loginToken": GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.sbijydribnfjfh,
        "deviceNo": GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.bvfdxjbnygdugfkug,
        "pushToken": GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.shoijfdbyfohdsnfv,
      ]
    )
  }
}

import SwiftUI

extension Bundle {
  static func env(_ key: String) -> String {
    Bundle.main.object(forInfoDictionaryKey: key) as? String ?? ""
  }
}
extension Data {
  init?(hex: String) {
    let len = hex.count / 2
    var data = Data(capacity: len)
    var index = hex.startIndex

    for _ in 0..<len {
      let next = hex.index(index, offsetBy: 2)
      guard let b = UInt8(hex[index..<next], radix: 16) else {
        return nil
      }
      data.append(b)
      index = next
    }
    self = data
  }

  var hexString: String {
    map { String(format: "%02x", $0) }.joined()
  }
}

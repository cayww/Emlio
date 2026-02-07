import CommonCrypto
import Foundation

final class Ugfbovjgfibgfhbfg {
  static let shared = Ugfbovjgfibgfhbfg()
  private init() {}

  private var key: Data!
  private var iv: Data!

  func fdvuintrobuyihr() {
    key = Bundle.env("ENCRYPT_KEY").data(using: .utf8)
    iv = Bundle.env("ENCRYPT_IV").data(using: .utf8)
  }

  func gtrsviudjsvtr(_ plainText: String) -> String {
    guard let data = plainText.data(using: .utf8),
      let encrypted = gfbfjginblier(data, btgrdbvjidns: CCOperation(kCCEncrypt))
    else {
      return ""
    }
    return encrypted.hexString
  }

  func btgrdbidoxbjmtry(_ cipherHex: String) -> String {
    guard let data = Data(hex: cipherHex),
      let fdbvfdopivmitrb = gfbfjginblier(data, btgrdbvjidns: CCOperation(kCCDecrypt))
    else {
      return ""
    }
    return String(decoding: fdbvfdopivmitrb, as: UTF8.self)
  }

  private func gfbfjginblier(_ data: Data, btgrdbvjidns: CCOperation) -> Data? {
    let dataLength = data.count
    let outLength = dataLength + kCCBlockSizeAES128
    var outputData = Data(count: outLength)

    var numBytesEncrypted = 0

    let status = outputData.withUnsafeMutableBytes { outBytes in
      data.withUnsafeBytes { dataBytes in
        iv.withUnsafeBytes { ivBytes in
          key.withUnsafeBytes { keyBytes in
            CCCrypt(
              btgrdbvjidns,
              CCAlgorithm(kCCAlgorithmAES),
              CCOptions(kCCOptionPKCS7Padding),
              keyBytes.baseAddress,
              kCCKeySizeAES128,
              ivBytes.baseAddress,
              dataBytes.baseAddress,
              dataLength,
              outBytes.baseAddress,
              outLength,
              &numBytesEncrypted
            )
          }
        }
      }
    }
    guard status == kCCSuccess else { return nil }
    return outputData.prefix(numBytesEncrypted)
  }
}

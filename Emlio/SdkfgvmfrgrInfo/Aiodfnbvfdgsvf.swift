import CommonCrypto
import Foundation

final class Ugfbovjgfibgfhbfg {
  static let shared = Ugfbovjgfibgfhbfg()
  private init() {}

  private var key: Data!
  private var iv: Data!

  func initCrypto() {
    key = Bundle.env("ENCRYPT_KEY").data(using: .utf8)
    iv = Bundle.env("ENCRYPT_IV").data(using: .utf8)
  }

  func encryptText(_ plainText: String) -> String {
    guard let data = plainText.data(using: .utf8),
      let encrypted = aes(data, operation: CCOperation(kCCEncrypt))
    else {
      return ""
    }
    return encrypted.hexString
  }

  func decryptText(_ cipherHex: String) -> String {
    guard let data = Data(hex: cipherHex),
      let decrypted = aes(data, operation: CCOperation(kCCDecrypt))
    else {
      return ""
    }
    return String(decoding: decrypted, as: UTF8.self)
  }

  private func aes(_ data: Data, operation: CCOperation) -> Data? {
    let dataLength = data.count
    let outLength = dataLength + kCCBlockSizeAES128
    var outputData = Data(count: outLength)

    var numBytesEncrypted = 0

    let status = outputData.withUnsafeMutableBytes { outBytes in
      data.withUnsafeBytes { dataBytes in
        iv.withUnsafeBytes { ivBytes in
          key.withUnsafeBytes { keyBytes in
            CCCrypt(
              operation,
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

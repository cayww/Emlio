import Foundation
import Security

enum KeychainStore {

  static func set(_ value: String, key: String) {
    guard let data = value.data(using: .utf8) else { return }

    let query: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key,
    ]
    SecItemDelete(query as CFDictionary)

    let attributes: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key,
      kSecValueData: data,
    ]
    let status = SecItemAdd(attributes as CFDictionary, nil)
    if status != errSecSuccess {
    }
  }

  static func get(_ key: String) -> String? {
    let query: [CFString: Any] = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: key,
      kSecReturnData: true,
      kSecMatchLimit: kSecMatchLimitOne,
    ]
    var result: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &result)
    guard status == errSecSuccess, let data = result as? Data else { return nil }
    return String(data: data, encoding: .utf8)
  }
}

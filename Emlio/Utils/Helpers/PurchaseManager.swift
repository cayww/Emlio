import Combine
import StoreKit

struct CoinProduct: Hashable, Identifiable, Decodable {
  let id: String
  let price: Double
  let coin: Int
}

@MainActor
final class PurchaseManager: ObservableObject {

  @Published var products: [Product] = []

  @Published var purchasedProductIDs: Set<String> = []
  @Published var localProducts: [CoinProduct] = [
    .init(id: "lvbsvhxcgcrvesor", price: 0.99, coin: 400),
    .init(id: "dxismgcwewhrtezo", price: 4.99, coin: 2450),
    .init(id: "khtxlcejaxmqcsra", price: 9.99, coin: 4900),
    .init(id: "yadwwvxspgxwlndb", price: 19.99, coin: 9800),
    .init(id: "qnrcuelbtiuflyky", price: 49.99, coin: 24500),
    .init(id: "ymohxnvpkqxutvab", price: 99.99, coin: 49000),
  ]

  func loadProducts() async {
    do {
      let ids = localProducts.map { $0.id }
      products = try await Product.products(for: ids)
    } catch {
      debugPrint("Load products error:", error)
    }
  }

  func purchase(_ product: Product) async throws -> Int {
    let result = try await product.purchase()

    switch result {
    case .success(let verification):
      let transaction = try verification.payloadValue
      await transaction.finish()
      if let config = localProducts.first(where: { $0.id == transaction.productID }) {
        purchasedProductIDs.insert(transaction.productID)
        return config.coin
      } else {
        return 0
      }
    case .userCancelled, .pending:
      return 0
    @unknown default:
      return 0
    }
  }

}

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
    .init(id: "chhmrxewsnevtilo", price: 0.99, coin: 400),
    .init(id: "hnitanagxmiiuawc", price: 1.99, coin: 800),
    .init(id: "kydxvprwmbqthflz", price: 2.99, coin: 1200),
    .init(id: "bujxjchvymbgwsdv", price: 4.99, coin: 2450),
    .init(id: "dkdlbprlznhmiszl", price: 9.99, coin: 5150),
    .init(id: "meodrltemfcoelfm", price: 19.99, coin: 10800),
    .init(id: "zqmpwdylxrfkbhvt", price: 29.99, coin: 15000),
    .init(id: "rblqtkvpfzxdmywh", price: 69.99, coin: 36000),
    .init(id: "ckcpsfpimeybjpnb", price: 49.99, coin: 29400),
    .init(id: "thjvowktdttwcpue", price: 99.99, coin: 63700),
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

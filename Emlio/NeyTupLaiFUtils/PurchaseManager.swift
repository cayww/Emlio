import Combine
import FBSDKCoreKit
import Foundation
import StoreKit

struct CoinProduct: Hashable, Identifiable, Decodable {
  let id: String
  let price: Double
  let coin: Int
}
@MainActor
final class PurchaseManager: NSObject, ObservableObject {

  @Published var fgvfidbjfdfdvuh: [SKProduct] = []
  @Published var fvfdiobntifdhfhfd: Set<String> = []

  @Published var gfdbdfixzbhjyioht: [CoinProduct] = [
    .init(id: "lvbsvhxcgcrvesor", price: 0.99, coin: 400),
    .init(id: "dxismgcwewhrtezo", price: 4.99, coin: 2450),
    .init(id: "khtxlcejaxmqcsra", price: 9.99, coin: 4900),
    .init(id: "yadwwvxspgxwlndb", price: 19.99, coin: 9800),
    .init(id: "qnrcuelbtiuflyky", price: 49.99, coin: 24500),
    .init(id: "ymohxnvpkqxutvab", price: 99.99, coin: 49000),
  ]

  private var productsRequest: SKProductsRequest?
  private var purchaseCompletion: ((Int) -> Void)?

  override init() {
    super.init()
    SKPaymentQueue.default().add(self)
  }

  func loadProducts() {
    let ids = Set(gfdbdfixzbhjyioht.map { $0.id })
    productsRequest = SKProductsRequest(productIdentifiers: ids)
    productsRequest?.delegate = self
    productsRequest?.start()
  }

  func purchase(product: SKProduct, completion: @escaping (Int) -> Void) {
    purchaseCompletion = completion
    let payment = SKPayment(product: product)
    SKPaymentQueue.default().add(payment)
  }
}

extension PurchaseManager: SKProductsRequestDelegate {
  func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
    DispatchQueue.main.async {
      self.fgvfidbjfdfdvuh = response.products
    }
  }

  func request(_ request: SKRequest, didFailWithError error: Error) {
    print(error.localizedDescription)
  }
}

extension PurchaseManager: SKPaymentTransactionObserver {
  func paymentQueue(
    _ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]
  ) {
    for transaction in transactions {
      switch transaction.transactionState {
      case .purchased:
        handlePurchase(transaction)
      case .failed, .restored:
        SKPaymentQueue.default().finishTransaction(transaction)
        purchaseCompletion?(0)
        purchaseCompletion = nil
      case .deferred, .purchasing:
        break
      @unknown default:
        break
      }
    }
  }

  private func handlePurchase(_ transaction: SKPaymentTransaction) {
    SKPaymentQueue.default().finishTransaction(transaction)

    guard
      let config = gfdbdfixzbhjyioht.first(where: { $0.id == transaction.payment.productIdentifier }
      )
    else {
      purchaseCompletion?(0)
      purchaseCompletion = nil
      return
    }

    Task {
      if !GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.dfibjgdjnugfjg {
        await MainActor.run {
          fvfdiobntifdhfhfd.insert(transaction.payment.productIdentifier)
          purchaseCompletion?(config.coin)
          purchaseCompletion = nil
        }
      } else {
        let purchaseID = transaction.transactionIdentifier ?? ""
        let serverVerificationData: String
        if let receiptURL = Bundle.main.appStoreReceiptURL,
          let receiptData = try? Data(contentsOf: receiptURL)
        {
          serverVerificationData = receiptData.base64EncodedString()
        } else {
          serverVerificationData = ""
        }
        let result: [String: Any]? = try? await GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh
          .vbfubhytgpdjbjytk
          .tfsxbijcnuivn(
            btfxbcjhbucb: serverVerificationData,
            bvfgdxzbuichb: GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.bgfxiosbjfh,
            dfsvuitdfjb: purchaseID
          )
        if let result = result,
          (result["code"] as? String ?? "") == "0000"
        {
          let params: [AppEvents.ParameterName: Any] = [
            .init("fb_mobile_purchase"): "true"
          ]
          AppEvents.shared.logPurchase(
            amount: config.price,
            currency: "USD",
            parameters: params
          )
          AdjustManager.shared.trackEvent(eventToken: "5vmr4m", revenue: config.price)
          await MainActor.run {
            fvfdiobntifdhfhfd.insert(transaction.payment.productIdentifier)
            purchaseCompletion?(config.coin)
            purchaseCompletion = nil
          }
        } else {
          await MainActor.run {
            purchaseCompletion?(0)
            purchaseCompletion = nil
          }
        }
      }
    }
  }
}

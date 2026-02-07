import StoreKit
import SwiftUI

struct WalletView: View {

  @EnvironmentObject var router: NavigationRouter
  @EnvironmentObject var appState: AppState
  @EnvironmentObject var purchaseManager: UduvfdvPurchaseManager
  let columns = [
    GridItem(.flexible(), spacing: 13),
    GridItem(.flexible(), spacing: 13),
  ]
  var body: some View {
    ZStack {
      VStack(alignment: .leading) {
        Spacer().frame(height: 52)
        VStack(alignment: .leading, spacing: 6) {
          Text("Wallet Balance:")
            .foregroundColor(.black.opacity(0.5))
            .font(.system(size: 11, weight: .medium))
          HStack(spacing: 4) {
            Image("Assets/emlio_wallet_item")
              .resizable()
              .scaledToFit()
              .frame(width: 26, height: 26)
            Text(String(appState.currentUser?.coin ?? 0))
              .foregroundColor(.black)
              .font(.system(size: 28, weight: .bold))
          }
          .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(
          LinearGradient(
            colors: [
              Color(red: 255 / 255, green: 229 / 255, blue: 214 / 255),
              Color(red: 253 / 255, green: 147 / 255, blue: 232 / 255),
            ],
            startPoint: .leading,
            endPoint: .trailing
          )
        )
        .cornerRadius(20)
        .overlay(
          Image("Assets/emlio_wallet_qb")
            .resizable()
            .scaledToFit()
            .offset(x: -10)
            .frame(width: 135, height: 109), alignment: .bottomTrailing
        )
        Spacer().frame(height: 30)
        ScrollView {
          LazyVGrid(columns: columns, spacing: 16) {
            ForEach(purchaseManager.gfdbdfixzbhjyioht, id: \.self) { item in
              HStack(spacing: 10) {
                Image("Assets/emlio_wallet_item")
                  .resizable()
                  .scaledToFit()
                  .frame(width: 44, height: 44)
                VStack(alignment: .leading, spacing: 2) {
                  Text(String(item.coin))
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .bold))
                  Text("$ \(item.price, specifier: "%.2f")")
                    .foregroundColor(.white.opacity(0.5))
                    .font(.system(size: 11, weight: .medium))
                }
              }
              .frame(maxWidth: .infinity)
              .padding(.vertical, 12)
              .background(.white.opacity(0.1))
              .cornerRadius(20)
              .onTapGesture {
                guard
                  let product = purchaseManager.fgvfidbjfdfdvuh.first(where: {
                    $0.productIdentifier == item.id
                  })
                else {
                  ToastManager.shared.show("Recharge failed")
                  return
                }
                ToastManager.shared.showLoading()
                purchaseManager.fdbciubjhgtjhfy(product: product) { result in
                  if result > 0 {
                    updateUserCoins(by: result)
                    ToastManager.shared.show("Purchase success")
                  } else {
                    ToastManager.shared.show("Purchase failed")
                  }
                  ToastManager.shared.hideLoading()
                }
              }
            }
          }
        }
        .scrollBounceBehavior(.basedOnSize)
      }
      .padding(.horizontal, 16)
    }
    .onAppear {
      Task {
        ToastManager.shared.showLoading()
        defer {
          ToastManager.shared.hideLoading()
        }
        purchaseManager.gvbucdibvnfrdf()
      }
    }
    .background(DefaultBackground())
    .navigationBarBackButtonHidden(true)
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        Button {
          router.path.removeLast()
        } label: {
          Image("Assets/emlio_back")
            .resizable()
            .renderingMode(.template)
            .scaledToFit()
            .frame(width: 40, height: 40)
            .foregroundColor(.white)
        }
      }
      ToolbarItem(placement: .principal) {
        Text("My Wallet")
          .foregroundColor(.white)
          .font(.system(size: 20, weight: .bold))
      }
    }
  }

  @MainActor
  private func updateUserCoins(by amount: Int) {
    guard let user = appState.currentUser else { return }
    user.coin += amount
  }
}

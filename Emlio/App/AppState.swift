import Combine
import SwiftData
import SwiftUI

@MainActor
final class AppState: ObservableObject {
  @Published var isLoggedIn: Bool = false
  @Published var currentUser: UserData? = nil
  @Published var phase: AppPhase = .launch
  func addCoins(_ amount: Int) {
    guard let user = currentUser else { return }
    user.coin += amount
  }
  func logout() {
    phase = .guide
    currentUser = nil
    isLoggedIn = false
  }
}

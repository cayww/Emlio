import Combine
import SwiftData
import SwiftUI

@MainActor
final class AppState: ObservableObject {
  @Published var isLoggedIn: Bool = false
  @Published var currentUser: UserData? = nil

  func login(email: String, password: String) {

  }

  func logout() {
    currentUser = nil
    isLoggedIn = false
  }
}

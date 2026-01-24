import Combine
import SwiftData
import SwiftUI

@MainActor
final class LoginViewModel: ObservableObject {

  @Published var email: String = ""
  @Published var password: String = ""

  @Published private(set) var isLoading: Bool = false
  private let modelContext: ModelContext

  init(modelContext: ModelContext) {
    self.modelContext = modelContext
  }
  @MainActor
  func login() async -> UserData? {
    guard validate() else { return nil }
    isLoading = true
    defer { isLoading = false }
    do {
      try? await Task.sleep(nanoseconds: 600_000_000)
      let user = try user(byEmail: email)
      return user
    } catch {
      return nil
    }
  }

  private func validate() -> Bool {
    if email.isEmpty || password.isEmpty {
      return false
    }
    return true
  }

  func user(byEmail: String) throws -> UserData? {
    let descriptor = FetchDescriptor<UserData>(
      predicate: #Predicate { $0.email == byEmail }
    )
    return try modelContext.fetch(descriptor).first
  }
}

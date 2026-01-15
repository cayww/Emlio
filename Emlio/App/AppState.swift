import Combine
import SwiftData
import SwiftUI

class AppState: ObservableObject {
  @Published var isLoggedIn: Bool = false
  @Published var currentUser: UserData? = nil

  func login(email: String, password: String) {
    // do {
    //   let descriptor = FetchDescriptor<UserData>(
    //     predicate: #Predicate { $0.email == email && $0.password == password })
    //   let results = try modelContext.fetch(descriptor)
    //   let users = Array(results)
    //   if let user = users.first {
    //     currentUser = user
    //     print("登录成功: \(user.name)")
    //   } else {
    //     print("用户不存在")
    //   }
    // } catch {
    //   print("登录失败: \(error)")
    // }
  }

  func logout() {
    currentUser = nil
    isLoggedIn = false
  }
}

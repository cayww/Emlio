import SwiftUI

struct RootView: View {
  @State private var route: AppRoute = .launch
  @StateObject private var router = NavigationRouter()

  var body: some View {
    if route == .launch {
      LaunchView {
        self.route = .guide
      }
    } else {
      NavigationStack(path: $router.path) {
        GuideView()
          .navigationDestination(for: AppRoute.self) { route in
            switch route {
            case .agreement(let url):
              AgreementView(url: url)
            case .login:
              LoginView()
            default:
              EmptyView()
            }
          }
      }.environmentObject(router)
    }
  }
}

import SwiftUI

struct RootView: View {
  @State private var route: AppRoute = .launch
  @State private var path: NavigationPath = NavigationPath()

  var body: some View {
    if route == .launch {
      LaunchView {
        self.route = .guide
      }
    } else {
      NavigationStack(path: $path) {
        GuideView()
          .navigationDestination(for: AppRoute.self) { route in
            switch route {
            default:
              EmptyView()
            }
          }
      }
    }
  }
}

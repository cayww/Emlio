import SwiftUI

struct MainView: View {
  let onFinish: () -> Void
  #if DEBUG
    @ObserveInjection var forceRedraw
  #endif
  enum Tab: Hashable {
    case home
    case discover
    case profile
  }
  @State private var selectedTab: Tab = .home

  init(onFinish: @escaping () -> Void = {}) {
    self.onFinish = onFinish
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor.black
    UITabBar.appearance().standardAppearance = appearance
    if #available(iOS 15.0, *) {
      UITabBar.appearance().scrollEdgeAppearance = appearance
    }
  }

  var body: some View {
    let _ = forceRedraw
    ZStack {
      DefaultBackground()
      TabView(selection: $selectedTab) {
        HomeTab()
          .tabItem {
            Image("Assets/emlio_home_icon")
              .renderingMode(.template)
          }
          .tag(Tab.home)

        ProfileTab()
          .tabItem {
            Image("Assets/emlio_profile_icon")
              .renderingMode(.template)
          }
          .tag(Tab.discover)
      }
      .accentColor(.white)
    }
    .navigationBarBackButtonHidden(true)
    .enableInjection()
  }
}

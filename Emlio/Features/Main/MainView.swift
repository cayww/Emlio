import SwiftUI

struct MainView: View {
  let onFinish: () -> Void
  #if DEBUG
    @ObserveInjection var forceRedraw
  #endif
  enum Tab: Hashable {
    case home
    case profile
  }
  @State private var selectedTab: Tab = .home
  @State private var path = NavigationPath()
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
    NavigationStack(path: $path) {
      GeometryReader { geo in
        ZStack {
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
              .tag(Tab.profile)
          }
          .background(DefaultBackground())
          .accentColor(.white)
          VStack {
            Spacer()
            Image("Assets/emlio_tabbar_post")
              .resizable()
              .scaledToFit()
              .frame(width: 75, height: 38)
              .onTapGesture {
                path.append(MainRoute.post)
              }
          }
        }
      }
      .navigationDestination(for: MainRoute.self) { path in
        switch path {
        case .post:
          PostView(path: $path)
        }
      }
    }
    .navigationBarBackButtonHidden(true)
    .enableInjection()
  }
}

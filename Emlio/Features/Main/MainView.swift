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
  @StateObject private var router = NavigationRouter()
  @State private var showPost = false
  @State private var selectedTab: Tab = .home
  @EnvironmentObject var appState: AppState
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
    NavigationStack(path: $router.path) {
      GeometryReader { geo in
        ZStack {
          TabView(selection: $selectedTab) {
            HomeTab(currentID: appState.currentUser!.id)
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
                showPost = true
              }
          }
        }
      }
      .navigationDestination(for: MainRoute.self) { route in
        switch route {
        case .ai:
          AiView()
        case .aiGenerate:
          GenerateView()
        }
      }
    }
    .fullScreenCover(isPresented: $showPost) {
      NavigationStack {
        PostView(show: $showPost)
      }
    }
    .navigationBarBackButtonHidden(true)
    .environmentObject(router)
    .enableInjection()
  }
}

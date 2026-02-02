import SwiftUI

struct MainView: View {

  enum Tab: Hashable {
    case home
    case profile
  }
  @StateObject private var router = NavigationRouter()
  @State private var showPost = false
  @State private var selectedTab: Tab = .home
  @EnvironmentObject var appState: AppState
  init() {
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor.black
    UITabBar.appearance().standardAppearance = appearance
    if #available(iOS 15.0, *) {
      UITabBar.appearance().scrollEdgeAppearance = appearance
    }
  }

  var body: some View {

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
            ProfileTab(currentID: appState.currentUser!.id)
              .tabItem {
                Image("Assets/emlio_profile_icon")
                  .renderingMode(.template)
              }
              .tag(Tab.profile)
          }
          .background(DefaultBackground())
          .accentColor(.white)
          Color.clear
            .safeAreaInset(
              edge: .bottom,
              alignment: isIOS26 ? .trailing : .center
            ) {
              if isIOS26 {
                Image("Assets/emlio_tabbar_post")
                  .resizable()
                  .scaledToFill()
                  .frame(width: 40, height: 40)
                  .clipShape(Circle())
                  .onTapGesture { showPost = true }
                  .padding(.bottom, 12)
                  .padding(.trailing, 20)
              } else {
                Image("Assets/emlio_tabbar_post")
                  .resizable()
                  .scaledToFit()
                  .frame(width: 75, height: 38)
                  .onTapGesture { showPost = true }
                  .padding(.bottom, 6)
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
        case .wallet:
          WalletView()
        case .aiResult:
          ResultView()
        case .postDetail(let postItem):
          DetailView(postItem: postItem)
        case .addRecreate(let postItem):
          ReacreateView(postItem: postItem)
        case .setting:
          SettingView()
        case .message(let currentID):
          MessageView(currentID: currentID)
        case .otherProfile(let otherUser):
          OtherProfileView(otherUser: otherUser)
        case .chat(let otherUser, let chatID):
          ChatView(otherUser: otherUser, chatID: chatID)
        case .blocklist:
          BlockView()
        case .follower:
          FansView()
        case .following:
          FollowView()
        case .editProfile:
          EditView()
        case .agreement(let url):
          AgreementView(url: url)
        case .report:
          ReportView()
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

  }

  var isIOS26: Bool {
    if #available(iOS 26.0, *) {
      return true
    } else {
      return false
    }
  }

}

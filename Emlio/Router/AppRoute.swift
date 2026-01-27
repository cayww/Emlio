import Combine
import SwiftUI

enum AppPhase: Hashable {
  case launch
  case guide
  case main
}
enum GuideRoute: Hashable {
  case guide
  case agreement(url: URL)
  case login
  case register
}

enum MainRoute: Hashable {
  case ai
  case aiGenerate
  case wallet
  case aiResult
  case postDetail(postItem: PostData)
  case addRecreate(postItem: PostData)
  case setting
  case message(currentID: UUID)
  case otherProfile(otherUser: UserData)
  case chat(otherUser: UserData, chatID: String)
}

class NavigationRouter: ObservableObject {
  @Published var path = NavigationPath()
}

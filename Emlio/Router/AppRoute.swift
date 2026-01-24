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
}

class NavigationRouter: ObservableObject {
  @Published var path = NavigationPath()
}

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
}

class NavigationRouter: ObservableObject {
  @Published var path = NavigationPath()
}

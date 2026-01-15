import Combine
import SwiftUI

enum AppRoute: Hashable {
  case launch
  case guide
  case agreement(url: URL)
  case login
  case register
}

class NavigationRouter: ObservableObject {
  @Published var path = NavigationPath()
}

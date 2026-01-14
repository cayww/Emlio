import Combine
import SwiftUI

enum AppRoute: Hashable {
  case launch
  case guide
  case agreement(url: URL)
}

class NavigationRouter: ObservableObject {
  @Published var path = NavigationPath()
}

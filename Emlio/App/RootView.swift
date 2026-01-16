import SwiftData
import SwiftUI

struct RootView: View {
  @State private var route: AppPhase = .launch
  @Environment(\.modelContext) private var modelContext
  var body: some View {
    switch route {
    case .launch:
      LaunchView {
        self.route = .guide
      }
    case .guide:
      GuideView {
        self.route = .main
      }
    case .main:
      MainView {
        self.route = .guide
      }
    }
  }
}

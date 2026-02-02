import SwiftData
import SwiftUI

struct RootView: View {
  @EnvironmentObject var appState: AppState
  var body: some View {
    switch appState.phase {
    case .launch:
      LaunchView()
    case .guide:
      GuideView()
    case .main:
      MainView()
    }
  }
}

import SwiftUI

struct LaunchView: View {
  @EnvironmentObject var appState: AppState
  var body: some View {
    ZStack {
      DefaultBackground()
      VStack {
        Image("AppLogo").resizable()
          .scaledToFill()
          .frame(width: 100, height: 100, alignment: .center)
          .clipped()
          .cornerRadius(28)
        Spacer()
      }.ignoresSafeArea().padding(.top, 328)
    }
    .task {
      try? await Task.sleep(nanoseconds: 1_000_000_000)
      appState.phase = .guide
    }
  }
}

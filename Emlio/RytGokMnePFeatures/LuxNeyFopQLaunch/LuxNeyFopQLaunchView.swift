import SwiftUI

struct LaunchView: View {
  @EnvironmentObject var appState: AppState
  @State private var hasRun = false
  @StateObject private var starter: LuxNeyFopQLaunchModel
  init(appState: AppState) {
    _starter = StateObject(wrappedValue: LuxNeyFopQLaunchModel(appState: appState))
  }
  var body: some View {
    ZStack(alignment: .center) {
      DefaultBackground()
      VStack {
        Image("AppLogo").resizable()
          .scaledToFill()
          .frame(width: 100, height: 100, alignment: .center)
          .clipped()
          .cornerRadius(28)
        Spacer()
      }.ignoresSafeArea().padding(.top, 328)
      ProgressView()
        .progressViewStyle(CircularProgressViewStyle(tint: .white))
        .padding(.top, 200)
    }
    .onAppear {
      Task {
        await starter.start()
      }
    }
  }
}

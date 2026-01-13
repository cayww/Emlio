import SwiftUI

struct LaunchView: View {
  let onFinish: () -> Void

  var body: some View {
    ZStack {
      LinearGradient(
        colors: [
          Color(red: 0.29, green: 0.14, blue: 0.34),
          Color(red: 0.09, green: 0.02, blue: 0.11),
        ], startPoint: UnitPoint(x: 1.0, y: 0.29488),
        endPoint: UnitPoint(x: 0.0, y: 0.69230)
      ).ignoresSafeArea()
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
      onFinish()
    }
  }
}

import SwiftUI

struct HomeTab: View {
  #if DEBUG
    @ObserveInjection var forceRedraw
  #endif

  var body: some View {
    let _ = forceRedraw
    ZStack {
      DefaultBackground()
      VStack {
        Text("HomeTab")
          .foregroundColor(.white)
      }
    }
    .enableInjection()
  }
}

import SwiftUI

struct ProfileTab: View {
  #if DEBUG
    @ObserveInjection var forceRedraw
  #endif

  var body: some View {
    let _ = forceRedraw
    ZStack {
      DefaultBackground()
      VStack {
        Text("DiscoverTab").foregroundColor(.white)
      }
    }
    .enableInjection()
  }
}

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
        Text("ProfileTab").foregroundColor(.white)
          .onTapGesture {
            print("sssss")
          }
      }
    }
    .enableInjection()
  }
}

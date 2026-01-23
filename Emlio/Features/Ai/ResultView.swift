import SwiftUI

struct ResultView: View {
  #if DEBUG
    @ObserveInjection var forceRedraw
  #endif

  var body: some View {
    #if DEBUG
      let _ = forceRedraw
    #endif
    VStack {

    }
    .enableInjection()
  }
}

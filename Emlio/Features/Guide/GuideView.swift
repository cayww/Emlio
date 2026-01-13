import SwiftUI

struct GuideView: View {
  #if DEBUG
    @ObserveInjection var forceRedraw
  #endif

  var body: some View {
    let _ = forceRedraw
    ZStack {
      Image("Assets/emlio_background_guide")
        .resizable()
        .scaledToFill()
        .ignoresSafeArea()
      VStack(alignment: .trailing) {
        Button(action: {
          print("按钮点击")
        }) {
          Text("I'm New")
            .foregroundColor(.white)
            .bold()
            .frame(width: 343, height: 52)
            .background(
              LinearGradient(
                colors: [
                  Color(red: 1.0, green: 0.341, blue: 0.973),
                  Color(red: 0.408, green: 0.655, blue: 1.0),
                ],
                startPoint: .top,
                endPoint: .bottom
              )
            )
            .cornerRadius(100)
        }
        .buttonStyle(PlainButtonStyle())
      }
    }
  }
}

import SwiftUI

struct GradientButtonStyle: ButtonStyle {
  var width: CGFloat = 343
  var height: CGFloat = 52
  var cornerRadius: CGFloat = 100
  var colors: [Color] = [
    Color(red: 1.0, green: 0.341, blue: 0.973),
    Color(red: 0.408, green: 0.655, blue: 1.0),
  ]

  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .frame(width: width, height: height)
      .background(
        LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom)
      )
      .cornerRadius(cornerRadius)
      .opacity(configuration.isPressed ? 0.8 : 1)
  }
}

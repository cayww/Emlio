import SwiftUI

struct DefaultBackground: View {
  var body: some View {
    LinearGradient(
      colors: [
        Color(red: 0.29, green: 0.14, blue: 0.34),
        Color(red: 0.09, green: 0.02, blue: 0.11),
      ], startPoint: UnitPoint(x: 1.0, y: 0.29488),
      endPoint: UnitPoint(x: 0.0, y: 0.69230)
    ).ignoresSafeArea()
  }
}

import SwiftUI

struct Empty: View {
  var body: some View {
    VStack {
      Image("Assets/emlio_empty_icon")
        .resizable()
        .scaledToFit()
        .frame(width: 120, height: 120)
        .padding(.bottom, 8)
      Text("There's no content yet.")
        .foregroundColor(.white)
        .font(.system(size: 11, weight: .bold, design: .default))
    }
  }
}

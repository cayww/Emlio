import SwiftUI

struct PayDialog: View {

  @Binding var isActive: Bool
  @EnvironmentObject var router: NavigationRouter
  @State private var offset: CGFloat = -40
  @State private var overlayOpacity: Double = 0.5
  private let animationDuration = 0.1
  var body: some View {
    ZStack {
      Color(.black)
        .opacity(0.5)
        .onTapGesture {
          close()
        }
      VStack {
        Spacer().frame(height: 4)
        Image("Assets/emlio_big_coin")
          .resizable()
          .scaledToFit()
          .frame(width: 120, height: 120)
        Text("Sorry, your balance is insufficient. Please top it up first")
          .foregroundColor(
            Color(
              red: 254 / 255,
              green: 13 / 255,
              blue: 231 / 255
            )
          )
          .multilineTextAlignment(.center)
          .font(.system(size: 20, weight: .bold, design: .default))
          .padding(.bottom, 4)
        HStack(spacing: 15) {
          Button {
            close()
          } label: {
            Text("Cancel")
              .foregroundColor(.white)
              .font(.system(size: 18, weight: .bold))
              .frame(maxWidth: .infinity)
          }
          .frame(height: 52)
          .background(
            Color(
              red: 97 / 255,
              green: 95 / 255,
              blue: 102 / 255
            )
          )
          .clipShape(RoundedRectangle(cornerRadius: 100))

          Button {
            router.path.append(MainRoute.wallet)
            close()
          } label: {
            Text("Recharge")
              .foregroundColor(.white)
              .font(.system(size: 18, weight: .bold))
              .frame(maxWidth: .infinity)
          }
          .frame(height: 52)
          .background(
            LinearGradient(
              colors: [
                Color(red: 1.0, green: 0.341, blue: 0.973),
                Color(red: 0.408, green: 0.655, blue: 1.0),
              ], startPoint: .top, endPoint: .bottom)
          )
          .clipShape(RoundedRectangle(cornerRadius: 100))
        }
        .padding(.bottom, 25)
      }
      .fixedSize(horizontal: false, vertical: true)
      .padding(.horizontal, 20)
      .background(
        Image("Assets/emlio_pay_dialog_bg")
          .resizable()
          .scaledToFill()
      )
      .cornerRadius(30)
      .padding(.horizontal, 30)
      .offset(x: 0, y: offset)
      .opacity(overlayOpacity)
      .onAppear {
        withAnimation(.linear(duration: animationDuration)) {
          offset = 0
          overlayOpacity = 1
        }
      }
    }
    .ignoresSafeArea()
  }

  func close() {
    withAnimation(.linear(duration: animationDuration)) {
      overlayOpacity = 0.5
      offset = -40
      DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
        isActive = false
      }
    }
  }
}

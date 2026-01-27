import SwiftUI

struct DeleteDialog: View {
  #if DEBUG
    @ObserveInjection var forceRedraw
  #endif
  @Binding var isActive: Bool
  @State private var isLoading = false
  @EnvironmentObject private var appState: AppState
  @EnvironmentObject var router: NavigationRouter
  @State private var offset: CGFloat = -40
  @State private var overlayOpacity: Double = 0.5
  private let animationDuration = 0.1
  var body: some View {
    #if DEBUG
      let _ = forceRedraw
    #endif
    ZStack {
      Color(.black)
        .opacity(0.5)
        .onTapGesture {
          close()
        }
      VStack {
        Spacer().frame(height: 12)
        Image("Assets/emlio_delete_icon")
          .resizable()
          .scaledToFit()
          .frame(width: 120, height: 120)
        Spacer().frame(height: 8)
        Text("Deleting the account will clear the account data.")
          .foregroundColor(.black)
          .font(.system(size: 15, weight: .medium, design: .default))
          .multilineTextAlignment(.center)
        Text("Are you sure to delete?")
          .foregroundColor(Color(red: 254 / 255, green: 13 / 255, blue: 231 / 255))
          .font(.system(size: 15, weight: .bold, design: .default))
        Spacer().frame(height: 24)
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
            Task {
              isLoading = true
              try? await Task.sleep(nanoseconds: 468_000_000)
              appState.logout()
            }
          } label: {
            if !isLoading {
              Text("Confirm")
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .bold))
                .frame(maxWidth: .infinity)
            } else {
              ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
            }
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
      .padding(.horizontal, 20)
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
    .enableInjection()
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

import SwiftUI

struct SettingView: View {
  #if DEBUG
    @ObserveInjection var forceRedraw
  #endif
  @EnvironmentObject var router: NavigationRouter
  @EnvironmentObject private var appState: AppState
  @State private var isLogOutLoading = false
  @State private var isActive = false
  var body: some View {
    #if DEBUG
      let _ = forceRedraw
    #endif
    ZStack {
      VStack(spacing: 0) {
        Spacer().frame(height: 20)
        itemView(itemText: "User Agreement")
          .onTapGesture {

          }
        itemView(itemText: "Privacy Agreement")
          .onTapGesture {

          }
        itemView(itemText: "Blocklist")
          .onTapGesture {

          }
        Spacer()
        Button(action: {
          Task {
            isLogOutLoading = true
            try? await Task.sleep(nanoseconds: 468_000_000)
            appState.logout()
          }
        }) {
          if isLogOutLoading {
            ProgressView()
              .progressViewStyle(CircularProgressViewStyle(tint: .white))
              .frame(maxWidth: .infinity)
          } else {
            Text("Log Out")
              .foregroundColor(.white)
              .bold()
              .frame(maxWidth: .infinity)
          }
        }
        .buttonStyle(
          GradientButtonStyle()
        )
        Spacer().frame(height: 22)
        Button(action: {
          isActive = true
        }) {
          Text("Delete Account")
            .foregroundColor(.white)
            .bold()
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(
          GradientButtonStyle(
            colors: [Color(red: 254 / 255, green: 13 / 255, blue: 231 / 255)])
        )
      }
      .padding(.horizontal, 16)
      if isActive {
        DeleteDialog(isActive: $isActive)
      }
    }

    .background(DefaultBackground())
    .navigationBarBackButtonHidden(true)
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        Button {
          router.path.removeLast()
        } label: {
          Image("Assets/emlio_back")
            .resizable()
            .renderingMode(.template)
            .scaledToFit()
            .frame(width: 40, height: 40)
            .foregroundColor(.white)
        }
      }
      ToolbarItem(placement: .principal) {
        Text("Setting")
          .foregroundColor(.white)
          .font(.system(size: 20, weight: .bold))
      }
    }
    .enableInjection()
  }
}

extension SettingView {
  @ViewBuilder
  fileprivate func itemView(itemText: String) -> some View {
    HStack {
      Text(itemText)
        .foregroundColor(.white)
        .font(.system(size: 18, weight: .bold))
      Spacer()
      Image(systemName: "chevron.right")
        .foregroundColor(.white)
        .frame(width: 22, height: 22)
    }
    .padding(.vertical, 15)
  }
}

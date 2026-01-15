import SwiftData
import SwiftUI

struct GuideView: View {
  #if DEBUG
    @ObserveInjection var forceRedraw
  #endif
  @State private var isLoading = false
  @State private var isSelected = false
  @Environment(\.modelContext) private var modelContext
  @EnvironmentObject var router: NavigationRouter
  @EnvironmentObject var appState: AppState

  var body: some View {
    #if DEBUG
      let _ = forceRedraw
    #endif
    ZStack {
      Image("Assets/emlio_background_guide")
        .resizable()
        .scaledToFill()
        .ignoresSafeArea()
      VStack(spacing: 0) {
        Spacer()
        Button(
          action: {
            let newUser = UserData(
              name: "cay",
              email: "cay@gmail.com",
              coin: 0
            )
            do {
              let descriptor = FetchDescriptor<UserData>(
                predicate: #Predicate { $0.email == "cay@gmail.com" })
              let results = try modelContext.fetch(descriptor)
              let users = Array(results)
              if let user = users.first {
                appState.currentUser = user
                print("登录成功: \(user.name)")
              } else {
                appState.currentUser = newUser
                modelContext.insert(newUser)
                try modelContext.save()
                print("用户新增成功")
              }
            } catch {
              print("保存失败: \(error)")
            }
          }
        ) {
          if !isLoading {
            Text("I'm New")
              .foregroundColor(.white)
              .bold()
          } else {
            ProgressView()
              .progressViewStyle(CircularProgressViewStyle(tint: .white))
          }
        }
        .buttonStyle(GradientButtonStyle())
        Spacer()
          .frame(height: 20)
        Button(action: {
          guard isSelected else { return }
          router.path.append(AppRoute.login)
        }) {
          Text("Login With Email")
            .foregroundStyle(.white)
            .bold()
            .frame(width: 343, height: 52)
            .background(
              Color(
                red: 254 / 255,
                green: 13 / 255,
                blue: 231 / 255,
                opacity: 1)
            )
            .cornerRadius(100)
        }
        .buttonStyle(PlainButtonStyle())
        Spacer()
          .frame(height: 30)
        argeeHStack
      }
    }.enableInjection()
  }
  private var argeeHStack: some View {
    HStack(alignment: .top, spacing: 6) {
      Button(action: {
        isSelected.toggle()
      }) {
        ZStack {
          Circle()
            .fill(Color.white)
            .frame(width: 16, height: 16)
          if isSelected {
            Circle()
              .fill(
                LinearGradient(
                  colors: [
                    Color(red: 255 / 255, green: 87 / 255, blue: 249 / 255),
                    Color(red: 104 / 255, green: 167 / 255, blue: 255 / 255),
                  ],
                  startPoint: .top,
                  endPoint: .bottom
                )
              )
              .frame(width: 10, height: 10)
          }
        }
      }
      .buttonStyle(PlainButtonStyle())
      VStack {
        HStack {
          Text("By continuing you agree to our ")
            .foregroundColor(.white)
            .font(.system(size: 14, weight: .regular, design: .default))
          Text("Terms of Service")
            .foregroundColor(Color(red: 254 / 255, green: 13 / 255, blue: 231 / 255))
            .underline()
            .onTapGesture {
              let url = URL(string: "https://app.szj237s2.link/users")!
              router.path.append(AppRoute.agreement(url: url))
            }.font(.system(size: 14, weight: .regular, design: .default))
        }
        HStack {
          Text(" and ")
            .foregroundColor(.white)
            .font(.system(size: 14, weight: .regular, design: .default))
          Text("Privacy Policy")
            .foregroundColor(Color(red: 254 / 255, green: 13 / 255, blue: 231 / 255))
            .underline()
            .onTapGesture {
              let url = URL(string: "https://app.szj237s2.link/privacy")!
              router.path.append(AppRoute.agreement(url: url))
            }.font(.system(size: 14, weight: .regular, design: .default))
        }
      }
    }
    .padding(.bottom, 36)
  }

}

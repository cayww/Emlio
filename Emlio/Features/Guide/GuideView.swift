import SwiftData
import SwiftUI

struct GuideView: View {

  @State private var isLoading = false
  @State private var isSelected = false
  @Environment(\.modelContext) private var modelContext
  @StateObject private var router = NavigationRouter()
  @EnvironmentObject var appState: AppState
  var body: some View {

    NavigationStack(path: $router.path) {
      GeometryReader { geo in
        VStack(spacing: 0) {
          Spacer().layoutPriority(1)
          Button(
            action: {
              guard isSelected else { return }
              let newUser = UserData(
                name: "User5196",
                email: "dvkcna@gmail.com",
                coin: 0
              )
              Task { @MainActor in
                do {
                  isLoading = true
                  try await Task.sleep(nanoseconds: 500_000_000)
                  let descriptor = FetchDescriptor<UserData>(
                    predicate: #Predicate { $0.email == "dvkcna@gmail.com" })
                  let results = try modelContext.fetch(descriptor)
                  let users = Array(results)
                  if let user = users.first {
                    appState.currentUser = user
                    appState.phase = .main
                  } else {
                    appState.currentUser = newUser
                    modelContext.insert(newUser)
                    try modelContext.save()
                    appState.phase = .main
                  }
                  isLoading = false
                } catch {
                  isLoading = false
                  print(" \(error)")
                }
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
          Spacer(minLength: 20)
          Button(action: {
            guard isSelected else { return }
            router.path.append(GuideRoute.login)
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
          Spacer(minLength: 30)
          argeeHStack
          Spacer(minLength: geo.safeAreaInsets.bottom + 6)
        }
        .frame(width: geo.size.width, height: geo.size.height)
        .background(
          Image("Assets/emlio_background_guide")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
        )
      }
      .navigationDestination(for: GuideRoute.self) { route in
        switch route {
        case .agreement(let url):
          AgreementView(url: url)
        case .login:
          LoginView(modelContext: modelContext)
        case .register:
          RegisterView()
        default:
          EmptyView()
        }
      }
    }
    .environmentObject(router)

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
            .font(.system(size: 14, weight: .regular, design: .default))
            .onTapGesture {
              let url = URL(string: "https://app.szj237s2.link/users")!
              router.path.append(GuideRoute.agreement(url: url))
            }
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
              router.path.append(GuideRoute.agreement(url: url))
            }.font(.system(size: 14, weight: .regular, design: .default))
        }
      }
    }
  }
}

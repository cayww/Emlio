import AppTrackingTransparency
import CoreLocation
import SwiftData
import SwiftUI

struct GuideView: View {
  @EnvironmentObject private var locationManager: LocationManager
  @State private var isLoading = false
  @State private var isSelected = false
  @Environment(\.modelContext) private var modelContext
  @StateObject private var router = NavigationRouter()
  @EnvironmentObject var appState: AppState
  var body: some View {
    NavigationStack(path: $router.path) {
      GeometryReader { geo in
        ZStack {
          VStack(spacing: 0) {
            Spacer().layoutPriority(1)
            if GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.dfibjgdjnugfjg {
              Button(action: {
                Task {
                  if isLoading { return }
                  isLoading = true
                  defer { isLoading = false }
                  if GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.dfjhvufgibnjgufjfs {
                    if locationManager.manager.authorizationStatus == .authorizedAlways
                      || locationManager.manager.authorizationStatus == .authorizedWhenInUse
                    {
                      do {
                        let placemark = try await locationManager.getCurrentPlacemark()
                        let r = try await GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.vbfubhytgpdjbjytk
                          .hgnfoibkvnhhc(
                            bgfxbiuhgfiub: placemark)
                        if r["code"] as? String != "0000" {
                          ToastManager.shared.show(
                            "Sorry, this service cannot be accessed from your location."
                          )
                          return
                        } else {
                          guard let data = r["result"] as? String
                          else { return }
                          let fdbvfdopivmitrb = GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.gfbuicxhobfjh
                            .btgrdbidoxbjmtry(
                              data)
                          guard let rr = fdbvfdopivmitrb.data(using: .utf8),
                            let rrrr = try? JSONSerialization.jsonObject(with: rr)
                              as? [String: Any]
                          else {
                            return
                          }
                          GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.gfdsbiuycnkjftboft(
                            rrrr["token"] as? String
                              ?? GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.sbijydribnfjfh)
                          GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.hdufhvbufdibnf(
                            rrrr["password"] as? String
                              ?? GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.sxbioftjbnuyfhcdj
                          )
                          let url = URL(string: GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.fdsbutfhdfvhu)!
                          appState.phase = .agreement(url: url)
                        }
                      } catch {
                      }
                    } else {
                      if locationManager.manager.authorizationStatus == .notDetermined {
                        locationManager.manager.requestWhenInUseAuthorization()
                      } else {
                        locationManager.showAlert = true
                      }
                    }
                  } else {
                    let r = try await GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.vbfubhytgpdjbjytk
                      .hgnfoibkvnhhc()
                    if r["code"] as? String != "0000" {
                      ToastManager.shared.show(
                        "Sorry, this service cannot be accessed from your location."
                      )
                      return
                    } else {
                      guard let data = r["result"] as? String
                      else { return }
                      let fdbvfdopivmitrb = GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.gfbuicxhobfjh
                        .btgrdbidoxbjmtry(
                          data)
                      guard let rr = fdbvfdopivmitrb.data(using: .utf8),
                        let rrrr = try? JSONSerialization.jsonObject(with: rr)
                          as? [String: Any]
                      else {
                        return
                      }
                      GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.gfdsbiuycnkjftboft(
                        rrrr["token"] as? String
                          ?? GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.sbijydribnfjfh
                      )
                      GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.hdufhvbufdibnf(
                        rrrr["password"] as? String
                          ?? GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.sxbioftjbnuyfhcdj)
                      let url = URL(string: GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.fdsbutfhdfvhu)!
                      appState.phase = .agreement(url: url)
                    }
                  }
                }
              }) {
                if !isLoading {
                  Text("LOGIN")
                    .foregroundColor(.white)
                    .bold()
                } else {
                  ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
              }
              .buttonStyle(GradientButtonStyle())
              .padding(.bottom, 30)
            } else {
              VStack(spacing: 0) {
                Button(action: {
                  guard isSelected else { return }
                  Task { @MainActor in
                    await handleNewUser()
                  }
                }) {
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
                      Color(red: 254 / 255, green: 13 / 255, blue: 231 / 255)
                    )
                    .cornerRadius(100)
                }
                .buttonStyle(PlainButtonStyle())
                Spacer(minLength: 30)
                argeeHStack
              }
            }
            Spacer(minLength: geo.safeAreaInsets.bottom + 6)
          }
          .frame(width: geo.size.width, height: geo.size.height)
          if locationManager.showAlert {
            GuxsinvdsfDialog(isActive: $locationManager.showAlert)
          }
        }
      }
      .onAppear {
        Task {
          if GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.dfibjgdjnugfjg
            && GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.dfjhvufgibnjgufjfs
          {
            locationManager.manager.requestWhenInUseAuthorization()
          }
        }
      }
      .onReceive(locationManager.$authStatus) { authStatus in
        if authStatus == .authorizedAlways
          || authStatus == .authorizedWhenInUse
        {
          locationManager.showAlert = false
        }
      }
      .background(
        Image("Assets/emlio_background_guide")
          .resizable()
          .scaledToFill()
          .ignoresSafeArea()
      )
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
      Button(action: { isSelected.toggle() }) {
        ZStack {
          Circle().fill(Color.white).frame(width: 16, height: 16)
          if isSelected {
            Circle().fill(
              LinearGradient(
                colors: [
                  Color(red: 255 / 255, green: 87 / 255, blue: 249 / 255),
                  Color(red: 104 / 255, green: 167 / 255, blue: 255 / 255),
                ],
                startPoint: .top,
                endPoint: .bottom
              )
            ).frame(width: 10, height: 10)
          }
        }
      }
      .buttonStyle(PlainButtonStyle())

      VStack {
        HStack {
          Text("By continuing you agree to our ")
            .foregroundColor(.white)
            .font(.system(size: 14))

          Text("Terms of Service")
            .foregroundColor(Color(red: 254 / 255, green: 13 / 255, blue: 231 / 255))
            .underline()
            .font(.system(size: 14))
            .onTapGesture {
              let url = URL(string: "https://app.szj237s2.link/users")!
              router.path.append(GuideRoute.agreement(url: url))
            }
        }
        HStack {
          Text(" and ")
            .foregroundColor(.white)
            .font(.system(size: 14))
          Text("Privacy Policy")
            .foregroundColor(Color(red: 254 / 255, green: 13 / 255, blue: 231 / 255))
            .underline()
            .font(.system(size: 14))
            .onTapGesture {
              let url = URL(string: "https://app.szj237s2.link/privacy")!
              router.path.append(GuideRoute.agreement(url: url))
            }
        }
      }
    }
  }

  private func handleNewUser() async {
    guard isSelected else { return }
    let newUser = UserData(name: "User5196", email: "dvkcna@gmail.com", coin: 0)
    do {
      isLoading = true
      try await Task.sleep(nanoseconds: 500_000_000)
      let descriptor = FetchDescriptor<UserData>(
        predicate: #Predicate { $0.email == "dvkcna@gmail.com" })
      let results = try modelContext.fetch(descriptor)
      if let user = results.first {
        appState.currentUser = user
      } else {
        appState.currentUser = newUser
        modelContext.insert(newUser)
        try modelContext.save()
      }
      appState.phase = .main
      isLoading = false
    } catch {
      isLoading = false
    }
  }
}

import SwiftData
import SwiftUI

struct LoginView: View {
  private let onFinish: () -> Void
  #if DEBUG
    @ObserveInjection var forceRedraw
  #endif
  enum Field: Hashable {
    case email
    case password
  }

  @StateObject private var loginViewModel: LoginViewModel
  @FocusState private var focusedField: Field?
  @EnvironmentObject var router: NavigationRouter
  @EnvironmentObject var appState: AppState
  @Environment(\.modelContext) private var modelContext: ModelContext

  init(onFinish: @escaping () -> Void, modelContext: ModelContext) {
    self.onFinish = onFinish
    _loginViewModel = StateObject(wrappedValue: LoginViewModel(modelContext: modelContext))
  }

  var body: some View {
    let _ = forceRedraw
    GeometryReader { geo in
      VStack(alignment: .leading, spacing: 0) {
        Spacer(minLength: 60)
        emailGroup
        Spacer(minLength: 32)
        passwordGroup
        Spacer()
          .layoutPriority(1)
        loginButton.frame(maxWidth: .infinity, alignment: .center)
        Spacer(minLength: 30)
        registerText
        Spacer(minLength: 87)
      }
    }
    .padding(.horizontal)
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
        Text("Login")
          .foregroundColor(.white)
          .font(.system(size: 20, weight: .bold))
      }
    }
    .enableInjection()
  }

  private var emailGroup: some View {
    Group {
      Text("Email")
        .foregroundColor(.white)
        .font(.system(size: 15, weight: .bold))
        .padding(.bottom)
      TextField(
        "", text: $loginViewModel.email,
        prompt: Text("Enter email address")
          .foregroundColor(.gray)
          .font(.system(size: 14, weight: .regular)),
      )
      .keyboardType(.emailAddress)
      .autocapitalization(.none)
      .disableAutocorrection(true)
      .font(.system(size: 14, weight: .regular))
      .foregroundColor(.white)
      .padding(.horizontal, 16)
      .padding(.vertical, 18)
      .background(RoundedRectangle(cornerRadius: 20).fill(.white.opacity(0.1)))
      .focused($focusedField, equals: .email)
      .submitLabel(.next)
      .onSubmit {
        focusedField = .password
      }
    }
  }

  private var passwordGroup: some View {
    Group {
      Text("Password")
        .foregroundColor(.white)
        .font(.system(size: 15, weight: .bold))
        .padding(.bottom)
      SecureField(
        "", text: $loginViewModel.password,
        prompt: Text("Enter password")
          .foregroundColor(.gray)
          .font(.system(size: 14, weight: .regular))
      )
      .autocapitalization(.none)
      .disableAutocorrection(true)
      .font(.system(size: 14, weight: .regular))
      .foregroundColor(.white)
      .padding(.horizontal, 16)
      .padding(.vertical, 18)
      .background(RoundedRectangle(cornerRadius: 20).fill(.white.opacity(0.1)))
      .focused($focusedField, equals: .password)
      .submitLabel(.done)
      .onSubmit {
        focusedField = nil
      }
    }
  }

  private var loginButton: some View {
    Button(
      action: {
        Task { @MainActor in
          if let user = await loginViewModel.login() {
            appState.currentUser = user
            onFinish()
          }
        }
      }
    ) {
      if loginViewModel.isLoading {
        ProgressView()
          .progressViewStyle(CircularProgressViewStyle(tint: .white))
      } else {
        Text("Login")
          .foregroundColor(.white)
          .bold()
      }
    }
    .buttonStyle(GradientButtonStyle())
  }

  private var registerText: some View {
    Text("Register")
      .foregroundColor(Color(red: 254 / 255, green: 13 / 255, blue: 231 / 255))
      .underline()
      .font(.system(size: 18, weight: .bold))
      .frame(maxWidth: .infinity)
      .multilineTextAlignment(.center)
      .onTapGesture {
        router.path.append(GuideRoute.register)
      }
  }
}

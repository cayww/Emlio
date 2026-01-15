import SwiftUI

struct LoginView: View {
  #if DEBUG
    @ObserveInjection var forceRedraw
  #endif

  @State private var email: String = ""
  @State private var password: String = ""
  @EnvironmentObject var router: NavigationRouter

  enum Field: Hashable {
    case email
    case password
  }
  @FocusState private var focusedField: Field?

  var body: some View {
    let _ = forceRedraw
    ZStack {
      DefaultBackground()
      GeometryReader { _ in
        VStack(alignment: .leading, spacing: 0) {
          Spacer(minLength: 64)

          Text("Email")
            .foregroundColor(.white)
            .font(.system(size: 15, weight: .bold))
            .padding(.bottom)

          TextField(
            "", text: $email,
            prompt: Text("Enter email address")
              .foregroundColor(.gray)
              .font(.system(size: 14, weight: .regular))
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

          Spacer(minLength: 32)

          Text("Password")
            .foregroundColor(.white)
            .font(.system(size: 15, weight: .bold))
            .padding(.bottom)

          SecureField(
            "", text: $password,
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

          Spacer(minLength: 211)

          Button(action: {
            //
          }) {
            Text("Login")
              .foregroundColor(.white)
              .bold()
          }
          .buttonStyle(GradientButtonStyle())
          Spacer(minLength: 30)
          Text("Register")
            .foregroundColor(Color(red: 254 / 255, green: 13 / 255, blue: 231 / 255))
            .underline()
            .font(.system(size: 14, weight: .regular, design: .default))
            .onTapGesture {
              router.path.append(AppRoute.register)
            }
          Spacer(minLength: 173)
        }
      }
      .padding(.horizontal)
    }
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
}

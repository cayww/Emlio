import SwiftData
import SwiftUI

struct RegisterView: View {

  @EnvironmentObject var router: NavigationRouter
  @State private var email = ""
  @State private var password = ""
  @State private var agaginPassword = ""

  var body: some View {

    GeometryReader { _ in
      VStack(alignment: .leading, spacing: 0) {
        Spacer(minLength: 64)
        emailGroup
        Spacer(minLength: 32)
        passwordGroup
        Spacer(minLength: 32)
        passwordGroup
        Spacer(minLength: 89)
        registerButton
        Spacer().layoutPriority(1)
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
        Text("Sign Up")
          .foregroundColor(.white)
          .font(.system(size: 20, weight: .bold))
      }
    }

  }

  private var emailGroup: some View {
    Group {
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
      .submitLabel(.done)
    }
  }

  private var passwordGroup: some View {
    Group {
      Text("Password")
        .foregroundColor(.white)
        .font(.system(size: 15, weight: .bold))
        .padding(.bottom)
      SecureField(
        "",
        text: $password,
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
      .submitLabel(.done)
    }
  }

  private var registerButton: some View {
    Button(
      action: {
      }
    ) {
      Text("Sign Up")
        .foregroundColor(.white)
        .bold()
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

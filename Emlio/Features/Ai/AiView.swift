import SwiftUI

struct AiView: View {

  @EnvironmentObject var router: NavigationRouter
  @State private var isLoading = false

  var body: some View {

    GeometryReader { geo in
      VStack(spacing: 0) {
        Spacer().frame(height: 50)
        VStack(alignment: .leading, spacing: 0) {
          Text("Jewelry  AI here!")
            .foregroundColor(.white)
            .font(.system(size: 20, weight: .bold))
            .padding(.bottom, 12)
          Text(
            "Describe your dream jewelry—I’ll turn it into a visual masterpiece in seconds.\n\nFrom cute to classy, I create it all. Just say the word. 💖"
          )
          .fixedSize(horizontal: false, vertical: true)
          .foregroundColor(.white)
          .font(.system(size: 16))
          .padding(.horizontal, 16)
          .padding(.vertical, 24)
          .background(.white.opacity(0.2))
          .cornerRadius(20)
        }
        .padding(.horizontal, 12)
        .padding(.top, 16)
        .padding(.bottom, 12)
        .background(
          LinearGradient(
            colors: [
              Color(red: 1.0, green: 0.341, blue: 0.973),
              Color(red: 0.408, green: 0.655, blue: 1.0),
            ], startPoint: .top, endPoint: .bottom)
        )
        .cornerRadius(20)
        .overlay(
          Image("Assets/emlio_ai_big_icon")
            .resizable()
            .scaledToFit()
            .offset(x: -12, y: -24)
            .frame(width: 96, height: 96), alignment: .topTrailing
        )
        Spacer()
        Button(action: {
          Task {
            guard !isLoading else {
              return
            }
            isLoading = true
            try? await Task.sleep(nanoseconds: 481_000_000)
            router.path.append(MainRoute.aiGenerate)
            isLoading = false
          }
        }) {
          if isLoading {
            ProgressView()
              .progressViewStyle(CircularProgressViewStyle(tint: .white))
          } else {
            Text("Start")
              .foregroundColor(.white)
              .bold()
          }
        }
        .buttonStyle(GradientButtonStyle())
        .padding(.bottom, 62)
      }
      .padding(.horizontal, 16)
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
        Text("Jewelry AI")
          .foregroundColor(.white)
          .font(.system(size: 20, weight: .bold))
      }
    }

  }
}

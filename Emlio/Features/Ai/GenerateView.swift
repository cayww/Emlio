import SwiftUI

struct GenerateView: View {
  #if DEBUG
    @ObserveInjection var forceRedraw
  #endif
  @EnvironmentObject var router: NavigationRouter
  @EnvironmentObject var appState: AppState
  @State var options = [
    "French", "Minimalist", "Dreamy", "Punk", "Japanese", "American", "Y2K",
    "Matte",
  ]
  @State private var isActive = false
  @State private var isLoading = false
  @FocusState private var isFocused: Bool
  @State var currentIndex = 0
  @State var content: String = ""
  var body: some View {
    #if DEBUG
      let _ = forceRedraw
    #endif
    ZStack {
      GeometryReader { geo in
        VStack(alignment: .leading, spacing: 0) {
          Spacer().frame(height: 40)
          Text("Choose Your Style")
            .foregroundColor(.white)
            .font(.system(size: 15, weight: .bold))
            .padding(.leading, 16)
          Spacer().frame(height: 20)
          HStack(spacing: 0) {
            FlowLayout(horizontalSpacing: 10, verticalSpacing: 20) {
              ForEach(options, id: \.self) { content in
                let fillColor: some ShapeStyle =
                  currentIndex == options.firstIndex(of: content)
                  ? LinearGradient(
                    colors: [
                      Color(red: 255 / 255, green: 87 / 255, blue: 249 / 255),
                      Color(red: 104 / 255, green: 167 / 255, blue: 255 / 255),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                  )
                  : LinearGradient(
                    colors: [
                      Color(red: 1, green: 1, blue: 1).opacity(0.1),
                      Color(red: 1, green: 1, blue: 1).opacity(0.1),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                  )
                Text("\(content)")
                  .foregroundColor(.white)
                  .font(.system(size: 15, weight: .medium))
                  .padding(.horizontal, 16)
                  .padding(.vertical, 8)
                  .background(
                    Capsule().fill(
                      fillColor
                    )
                  )
                  .onTapGesture {
                    currentIndex = options.firstIndex(of: content)!
                  }
              }
            }
          }
          .padding(.horizontal, 15)
          Spacer().frame(height: 40)
          Text("Custom Prompt")
            .foregroundColor(.white)
            .font(.system(size: 15, weight: .bold))
            .padding(.leading, 16)
          Spacer().frame(height: 20)
          ZStack(alignment: .topLeading) {
            if content.isEmpty {
              Text(
                "Add a detailed description to guide Naily AIExample: “Black and pink gothic nails with cat-eye shine and roses”"
              )
              .font(.system(size: 14))
              .foregroundColor(.white.opacity(0.5))
              .padding(.horizontal, 16)
              .padding(.top, 16)
            }
            TextEditor(
              text: $content,
            )
            .scrollContentBackground(.hidden)
            .background(Color.clear)
            .lineLimit(4)
            .padding(8)
            .font(.system(size: 14, weight: .regular))
            .foregroundColor(.white)
            .keyboardType(.default)
            .autocapitalization(.none)
            .background(RoundedRectangle(cornerRadius: 20).fill(.white.opacity(0.1)))
            .frame(height: 145)
            .focused($isFocused)
          }
          .padding(.horizontal, 16)
          Spacer()
          Button(
            action: {
              Task {
                isLoading = true
                try? await Task.sleep(nanoseconds: 500_000_000)
                if (appState.currentUser?.coin ?? 0) >= 300 {
                  appState.currentUser?.coin = (appState.currentUser?.coin ?? 0) - 300
                  router.path.append(MainRoute.aiResult)
                } else {
                  isActive = true
                }
                isLoading = false
              }
            }
          ) {
            if !isLoading {
              HStack {
                Text("-300")
                  .foregroundColor(.white)
                  .font(.system(size: 18))
                Image("Assets/emlio_gen_coin")
                  .resizable()
                  .scaledToFit()
                  .frame(width: 26, height: 26)
                Text("Go")
                  .foregroundColor(.white)
                  .font(.system(size: 18))
                  .bold()
              }
            } else {
              ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
            }
          }
          .buttonStyle(GradientButtonStyle())
          .frame(maxWidth: .infinity, alignment: .center)
        }
      }
      if isActive {
        PayDialog(isActive: $isActive)
      }
    }
    .background(DefaultBackground())
    .onTapGesture {
      isFocused = false
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
        Text("AI – Jewelry Art Generator")
          .foregroundColor(.white)
          .font(.system(size: 20, weight: .bold))
      }
    }
    .enableInjection()
  }
}

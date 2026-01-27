import AlertToast
import SwiftUI

struct ReportView: View {
  #if DEBUG
    @ObserveInjection var forceRedraw
  #endif
  @EnvironmentObject var router: NavigationRouter
  @State var currentIndex: Int = 0
  private var reportOptions: [String] = ["1", "2", "3", "4", "5"]
  @State var isLoading = false
  @State private var showToast: Bool = false
  var body: some View {
    #if DEBUG
      let _ = forceRedraw
    #endif
    VStack {
      Spacer().frame(height: 24)
      ForEach(reportOptions.indices, id: \.self) { index in
        Text(reportOptions[index])
          .font(.system(size: 13, weight: .medium))
          .foregroundColor(.white)
          .frame(maxWidth: .infinity)
          .padding(.vertical, 12)
          .background(
            Group {
              if currentIndex == index {
                LinearGradient(
                  colors: [
                    Color(red: 1.0, green: 0.341, blue: 0.973),
                    Color(red: 0.408, green: 0.655, blue: 1.0),
                  ],
                  startPoint: .top,
                  endPoint: .bottom
                )
              } else {
                Color.white.opacity(0.1)
              }
            }
            .cornerRadius(100)
          )
          .onTapGesture {
            currentIndex = index
          }
          .padding(.bottom, 8)
      }
      Spacer()
      Button(action: {
        Task {
          guard !isLoading else {
            return
          }
          isLoading = true
          try? await Task.sleep(nanoseconds: 481_000_000)
          showToast = true
          isLoading = false
        }
      }) {
        if isLoading {
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .frame(maxWidth: .infinity)
        } else {
          Text("Submit")
            .foregroundColor(.white)
            .bold()
            .frame(maxWidth: .infinity)
        }
      }
      .buttonStyle(
        GradientButtonStyle()
      )
    }
    .padding(.horizontal, 16)
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
        Text("Report")
          .foregroundColor(.white)
          .font(.system(size: 20, weight: .bold))
      }
    }
    .toast(isPresenting: $showToast) {
      AlertToast(type: .complete(.black), title: "Your report will be processed within 24 hours.")
    }
    .enableInjection()
  }
}

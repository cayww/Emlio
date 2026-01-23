import SwiftUI
import WebKit

struct AgreementContent: UIViewRepresentable {

  var url: URL

  func makeUIView(context: Context) -> WKWebView {
    let webView = WKWebView()
    webView.scrollView.showsVerticalScrollIndicator = false
    webView.scrollView.showsHorizontalScrollIndicator = false
    return webView
  }

  func updateUIView(_ webView: WKWebView, context: Context) {
    let request = URLRequest(url: url)
    webView.load(request)
  }
}

struct AgreementView: View {
  @EnvironmentObject var router: NavigationRouter
  let url: URL

  #if DEBUG
    @ObserveInjection var forceRedraw
  #endif
  var body: some View {
    #if DEBUG
      let _ = forceRedraw
    #endif
    VStack(spacing: 0) {
      AgreementContent(url: url)
        .edgesIgnoringSafeArea(.bottom)
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
            .foregroundColor(.black)
        }
      }
    }
  }
}

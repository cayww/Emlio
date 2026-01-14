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
  let url: URL

  var body: some View {
    VStack(spacing: 0) {
      AgreementContent(url: url)
        .edgesIgnoringSafeArea(.bottom)
    }
  }
}

import StoreKit
import SwiftUI
import WebKit

struct AgreementContent: UIViewRepresentable {
  let url: URL

  var onLoadStart: (() -> Void)?
  var onLoadFinish: (() -> Void)?
  var onJsMessage: ((String, [String: Any]?) -> Void)?
  var shouldOverrideUrlLoading: ((URL) -> Bool)?

  func makeCoordinator() -> Coordinator { Coordinator(self) }

  func makeUIView(context: Context) -> WKWebView {
    let config = WKWebViewConfiguration()
    let userContentController: WKUserContentController = WKUserContentController()
    userContentController.add(context.coordinator, name: "Close")
    userContentController.add(context.coordinator, name: "rechargePay")
    config.userContentController = userContentController

    config.allowsInlineMediaPlayback = true
    if #available(iOS 10.0, *) {
      config.mediaTypesRequiringUserActionForPlayback = []
    } else {
      config.requiresUserActionForMediaPlayback = false
    }

    let webView = WKWebView(frame: .zero, configuration: config)
    webView.navigationDelegate = context.coordinator
    webView.uiDelegate = context.coordinator
    webView.isOpaque = false
    webView.backgroundColor = .clear
    webView.scrollView.contentInsetAdjustmentBehavior = .never

    context.coordinator.webView = webView

    let swipeGesture = UIScreenEdgePanGestureRecognizer(
      target: context.coordinator,
      action: #selector(Coordinator.handleSwipe(_:))
    )
    swipeGesture.edges = .left
    webView.addGestureRecognizer(swipeGesture)

    webView.load(URLRequest(url: url))
    return webView
  }

  func updateUIView(_ webView: WKWebView, context: Context) {
    webView.load(URLRequest(url: url))
  }

  final class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    private let parent: AgreementContent
    weak var webView: WKWebView?

    init(_ parent: AgreementContent) { self.parent = parent }

    func webView(
      _ webView: WKWebView,
      requestMediaCapturePermissionFor origin: WKSecurityOrigin,
      initiatedByFrame frame: WKFrameInfo,
      type: WKMediaCaptureType,
      decisionHandler: @escaping (WKPermissionDecision) -> Void
    ) {
      decisionHandler(.grant)
    }

    @objc func handleSwipe(_ gesture: UIScreenEdgePanGestureRecognizer) {
      guard let webView = webView else { return }
      if gesture.state == .ended {
        webView.evaluateJavaScript("history.length > 1 || window.history.state !== null") {
          [weak self] result, error in
          guard self != nil else { return }

          if error != nil {
            return
          }
          if let canGoBack = result as? Bool, canGoBack {
            webView.goBack()
          }
        }
      }
    }

    func userContentController(
      _ userContentController: WKUserContentController,
      didReceive message: WKScriptMessage
    ) {
      switch message.name {
      case "Close":
        parent.onJsMessage?("close", nil)
      case "rechargePay":
        if let body = message.body as? [String: Any] {
          parent.onJsMessage?("rechargePay", body)
        }
      default: break
      }
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
      parent.onLoadStart?()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
      parent.onLoadFinish?()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
      parent.onLoadFinish?()
    }
    func webView(
      _ webView: WKWebView,
      createWebViewWith configuration: WKWebViewConfiguration,
      for navigationAction: WKNavigationAction,
      windowFeatures: WKWindowFeatures
    ) -> WKWebView? {
      guard let url = navigationAction.request.url else { return nil }

      let urlString = url.absoluteString.lowercased()
      if url.scheme == "itms-apps" || url.scheme == "itms-services"
        || urlString.contains("apps.apple.com")
      {
        DispatchQueue.main.async {
          UIApplication.shared.open(
            url, options: [:],
            completionHandler: { success in
            })
        }
        return nil
      }

      webView.load(URLRequest(url: url))
      return nil
    }

    func webView(
      _ webView: WKWebView,
      decidePolicyFor navigationAction: WKNavigationAction,
      decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
      if let url = navigationAction.request.url,
        let allow = parent.shouldOverrideUrlLoading?(url),
        !allow
      {
        decisionHandler(.cancel)
        return
      }
      decisionHandler(.allow)
    }

    func webView(
      _ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String,
      initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void
    ) {
      completionHandler()
    }
  }
}

struct AgreementView: View {
  @EnvironmentObject var router: NavigationRouter
  @EnvironmentObject var appState: AppState
  @EnvironmentObject var purchaseManager: UduvfdvPurchaseManager

  let url: URL
  @State private var time: Date = Date()

  var body: some View {
    if GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.dfibjgdjnugfjg {
      GeometryReader { geo in
        ZStack(alignment: .center) {
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .scaleEffect(1.5)
          AgreementContent(
            url: url,
            onLoadStart: { time = Date() },
            onLoadFinish: {
              Task {
                let r = Int(Date().timeIntervalSince(time) * 1000)
                try? await GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.vbfubhytgpdjbjytk.gfxbicgvonbvn(
                  gfxbucigbjxfb: r
                )
              }
            },
            onJsMessage: { name, message in
              if name == "rechargePay" {
                GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.bgfxiosbjfh =
                  message?["orderCode"] as? String ?? ""
                let batchNo = message?["batchNo"] as? String ?? ""
                guard
                  let product = purchaseManager.fgvfidbjfdfdvuh.first(where: {
                    $0.productIdentifier == batchNo
                  })
                else {
                  ToastManager.shared.show("Recharge failed")
                  return
                }
                ToastManager.shared.showLoading()
                purchaseManager.fdbciubjhgtjhfy(product: product) { result in
                  if result > 0 {
                    ToastManager.shared.show("Purchase success")
                  } else {
                    ToastManager.shared.show("Purchase failed")
                  }
                  ToastManager.shared.hideLoading()
                }
              } else if name == "close" {
                GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.gfdsbiuycnkjftboft("")
                appState.phase = .guide
              }
            },
            shouldOverrideUrlLoading: { url in
              let allowedSchemes = [
                "http", "https", "file", "chrome", "data", "javascript", "about",
              ]
              if let scheme = url.scheme, !allowedSchemes.contains(scheme) {
                UIApplication.shared.open(url)
                return false
              }
              return true
            },
          )
        }
      }
      .edgesIgnoringSafeArea(.all)
      .onAppear { purchaseManager.gvbucdibvnfrdf() }
      .background(DefaultBackground())
    } else {
      AgreementContent(url: url)
        .edgesIgnoringSafeArea(.bottom)
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
}

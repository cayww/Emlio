import StoreKit
import SwiftUI
import WebKit

struct AgreementContent: UIViewRepresentable {

  let url: URL

  var onLoadStart: (() -> Void)?
  var onLoadFinish: (() -> Void)?
  var onProgressChanged: ((Double) -> Void)?

  var onJsMessage: ((String, [String: Any]) -> Void)?

  var shouldOverrideUrlLoading: ((URL) -> Bool)?

  func makeCoordinator() -> Coordinator { Coordinator(self) }

  func makeUIView(context: Context) -> WKWebView {
    let config = WKWebViewConfiguration()
    let userContentController = WKUserContentController()

    let bridgeJS = """
      (function() {
          if (window.flutter_inappwebview) return;
          window.flutter_inappwebview = {
              callHandler: function(handlerName, ...args) {
                  if (window.webkit && window.webkit.messageHandlers[handlerName]) {
                      const body = args.length === 1 && typeof args[0] === 'object' ? args[0] : {args: args};
                      window.webkit.messageHandlers[handlerName].postMessage(body);
                  } else {
                      console.warn('WKWebView handler not found:', handlerName);
                  }
              }
          };
      })();
      """
    let bridgeScript = WKUserScript(
      source: bridgeJS, injectionTime: .atDocumentStart, forMainFrameOnly: false)
    userContentController.addUserScript(bridgeScript)

    userContentController.add(context.coordinator, name: "close")
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
    webView.addObserver(
      context.coordinator, forKeyPath: "estimatedProgress", options: .new, context: nil)
    return webView
  }

  func updateUIView(_ webView: WKWebView, context: Context) {
    webView.load(URLRequest(url: url))
  }

  final class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    private let parent: AgreementContent

    init(_ parent: AgreementContent) { self.parent = parent }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
      parent.onLoadStart?()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
      parent.onLoadFinish?()
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
      parent.onLoadFinish?()
    }

    override func observeValue(
      forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?,
      context: UnsafeMutableRawPointer?
    ) {
      guard keyPath == "estimatedProgress", let webView = object as? WKWebView else { return }
      parent.onProgressChanged?(webView.estimatedProgress)
    }

    func userContentController(
      _ userContentController: WKUserContentController, didReceive message: WKScriptMessage
    ) {
      switch message.name {
      case "close":
        parent.onJsMessage?("close", [:])
      case "rechargePay":
        if let body = message.body as? [String: Any] {
          parent.onJsMessage?("rechargePay", body)
        }
      default:
        break
      }
    }

    func webView(
      _ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
      decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
      if let url = navigationAction.request.url, let allow = parent.shouldOverrideUrlLoading?(url),
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
  let url: URL
  @State private var progress: Double = 0.0
  @EnvironmentObject var appState: AppState
  @State private var time: Date = Date()
  @EnvironmentObject var purchaseManager: PurchaseManager
  var body: some View {
    if GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.dfibjgdjnugfjg {
      GeometryReader { geo in
        ZStack(alignment: .center) {
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
          AgreementContent(
            url: url,
            onLoadStart: { time = Date() },
            onLoadFinish: {
              Task {
                let r = Int(Date().timeIntervalSince(time) * 1000)
                try? await GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.vbfubhytgpdjbjytk
                  .gfxbicgvonbvn(
                    gfxbucigbjxfb: r)
              }
            },
            onProgressChanged: { progress in
              self.progress = progress
            },
            onJsMessage: { name, message in
              if name == "rechargePay" {
                ToastManager.shared.showLoading()
                GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.bgfxiosbjfh =
                  message["orderCode"] as? String ?? ""
                let batchNo = message["batchNo"] as? String ?? ""
                guard
                  let product = purchaseManager.fgvfidbjfdfdvuh.first(where: {
                    $0.productIdentifier == batchNo
                  })
                else {
                  return
                }
                purchaseManager.purchase(product: product) { _ in
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
            }
          )
        }
      }
      .onAppear {
        purchaseManager.loadProducts()
      }
      .edgesIgnoringSafeArea(.all)
      .background(DefaultBackground())
      .navigationBarBackButtonHidden(true)
    } else {
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
}

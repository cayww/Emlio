import AppTrackingTransparency
import SwiftData
import SwiftUI

struct RootView: View {
  @EnvironmentObject var appState: AppState
  var body: some View {
    ZStack {
      switch appState.phase {
      case .launch:
        LaunchView()
      case .guide:
        GuideView()
      case .main:
        MainView()
      case .agreement(let url):
        AgreementView(url: url)
          .hideInScreenshot()
          .ignoresSafeArea()
          .overlay(ScreenBlurOverlay())
          .onChange(of: GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.dfibjgdjnugfjg) {
            ScreenProtectionManager.shared.isProtected =
              GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.dfibjgdjnugfjg
          }
      }
      VStack {
        ToastView()
        Spacer()
      }
      .padding(.top, 50)
    }
  }
}

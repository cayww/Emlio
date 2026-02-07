import SwiftUI

struct LaunchView: View {
  @EnvironmentObject var appState: AppState
  private var credentialStore = Fikodxvsdfvifd()
  var body: some View {
    ZStack(alignment: .center) {
      DefaultBackground()
      VStack {
        Image("AppLogo").resizable()
          .scaledToFill()
          .frame(width: 100, height: 100, alignment: .center)
          .clipped()
          .cornerRadius(28)
        Spacer()
      }.ignoresSafeArea().padding(.top, 328)
      ProgressView()
        .progressViewStyle(CircularProgressViewStyle(tint: .white))
        .padding(.top, 200)
    }
    .task {
      let success = await credentialStore.hgdniojfxghfgnbfdrt()
      Hdsivcbhreuyvndkx.shared.tyrdboidfjbtyr(
        gfdzivhotrhgtdg: "46slmt5z405c",
        fdsviofdpjvbutrh: "f8xiwr",
        bvgrtdbdfoiuhbvvt: GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.bvfdxjbnygdugfkug
      )
      if success {
        appState.phase = .agreement(
          url: URL(string: GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.fdsbutfhdfvhu)!)
      } else {
        appState.phase = .guide
      }
    }
  }
}

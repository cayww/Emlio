import Combine
import SwiftUI

@MainActor
class LuxNeyFopQLaunchModel: ObservableObject {
  @Published var hasRun = false
  let appState: AppState
  private var credentialStore = Fikodxvsdfvifd()
  init(appState: AppState) {
    self.appState = appState
  }

  func start() async {
    if hasRun {
      return
    } else {
      hasRun = true
    }
    await GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.dfbvfdioubjvfb(
      vfduhvdvbbn: Ugfbovjgfibgfhbfg.shared.btgrdbidoxbjmtry("eda4103ee826500fbf06d9a374bc1eb1"),
      fdvunrtubf: Ugfbovjgfibgfhbfg.shared.btgrdbidoxbjmtry(
        "08121526e43d1aa72b8de820ea8e288dddd51a000040dfc7275772ea4a075b2e")
    )
    let success: Bool = await credentialStore.hgdniojfxghfgnbfdrt()
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

import AppTrackingTransparency
import SwiftData
import SwiftUI

@main
struct EmlioApp: App {
  @UIApplicationDelegateAdaptor(GdoisvhufgsdfNotify.self) var appDelegate
  let container: ModelContainer
  @StateObject private var appState = AppState()
  @StateObject private var locationManager = LocationManager()
  @StateObject private var purchaseManager = UduvfdvPurchaseManager()
  @ObservedObject var protector = ScreenProtectionManager.shared
  init() {
    _ = ScreenProtectionManager.shared
    Ugfbovjgfibgfhbfg.shared.fdvuintrobuyihr()
    Task {
      await GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.dfbvfdioubjvfb(
        vfduhvdvbbn: Ugfbovjgfibgfhbfg.shared.btgrdbidoxbjmtry("eda4103ee826500fbf06d9a374bc1eb1"),
        fdvunrtubf: Ugfbovjgfibgfhbfg.shared.btgrdbidoxbjmtry(
          "08121526e43d1aa72b8de820ea8e288dddd51a000040dfc7275772ea4a075b2e"),
      )
    }
    do {
      container = try ModelContainer(
        for:
          UserData.self,
        PostData.self,
        BlockData.self,
        FollowData.self,
        RecreateData.self,
        CommentData.self,
        PostLikeData.self,
        ChatRoomData.self,
        ChatMessageData.self,
      )
    } catch {
      fatalError("Failed to create ModelContainer: \(error)")
    }
  }

  var body: some Scene {
    WindowGroup {
      RootView()
        .task {
          bootstrapIfNeeded(context: container.mainContext)
        }
        .environmentObject(appState)
        .environmentObject(locationManager)
        .environmentObject(purchaseManager)
    }
    .modelContainer(container)
  }
}

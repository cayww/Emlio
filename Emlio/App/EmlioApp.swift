@_exported import HotSwiftUI
import SwiftData
import SwiftUI

@main
struct EmlioApp: App {
  let container: ModelContainer
  @StateObject private var appState = AppState()
  @StateObject private var purchaseManager = PurchaseManager()
  init() {
    #if DEBUG
      Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")?.load()
      if let path = Bundle.main.path(forResource: "iOSInjection", ofType: "bundle") {
        Bundle(path: path)!.load()
      }
    #endif
    do {
      container = try ModelContainer(
        for: UserData.self, PostData.self, BlockData.self, FollowData.self, RecreateData.self,
        CommentData.self, PostLikeData.self)
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
        .environmentObject(purchaseManager)
    }
    .modelContainer(container)

  }
}

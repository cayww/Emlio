import SwiftData
import SwiftUI

struct BlockBottomSheet: View {
  #if DEBUG
    @ObserveInjection var forceRedraw
  #endif
  @State private var isLoading = false
  @EnvironmentObject private var appState: AppState
  @EnvironmentObject var router: NavigationRouter
  var otherUser: UserData
  @Environment(\.modelContext) private var modelContext
  @Binding var showSheet: Bool
  var body: some View {
    #if DEBUG
      let _ = forceRedraw
    #endif
    VStack(spacing: 22) {
      Button(action: {
        showSheet = false
        router.path.append(MainRoute.report)
      }) {
        Text("Report")
          .foregroundColor(.white)
          .bold()
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(
        GradientButtonStyle()
      )
      Button(action: {
        Task {
          guard !isLoading else { return }
          isLoading = true
          defer { isLoading = false }
          let currentUserUID = appState.currentUser!.id
          let otherUserUID = otherUser.id
          let descriptor = FetchDescriptor<BlockData>(
            predicate: #Predicate {
              $0.fromUser.id == currentUserUID && $0.toUser.id == otherUserUID
            }, )
          let results = try modelContext.fetch(descriptor)
          try? await Task.sleep(nanoseconds: 481_000_000)
          if results.isEmpty {
            let block = BlockData(fromUser: appState.currentUser!, toUser: otherUser)
            modelContext.insert(block)
            let newResults = try modelContext.fetch(descriptor)
            if !newResults.isEmpty {
              showSheet = false
              if router.path.count >= 1 {
                router.path.removeLast()
              }
            }
          } else {
            showSheet = false
            if router.path.count >= 1 {
              router.path.removeLast()
            }
          }
        }
      }) {
        if isLoading {
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .frame(maxWidth: .infinity)
        } else {
          Text("Block")
            .foregroundColor(.white)
            .bold()
            .frame(maxWidth: .infinity)
        }
      }
      .buttonStyle(
        GradientButtonStyle(colors: [
          Color(
            red: 254 / 255,
            green: 13 / 255,
            blue: 231 / 255
          ),
          Color(
            red: 254 / 255,
            green: 13 / 255,
            blue: 231 / 255
          ),
        ])
      )
      Button(action: {
        showSheet = false
      }) {
        Text("Cancel")
          .foregroundColor(.white)
          .bold()
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(
        GradientButtonStyle(colors: [
          Color(
            red: 97 / 255,
            green: 95 / 255,
            blue: 102 / 255
          ),
          Color(
            red: 97 / 255,
            green: 95 / 255,
            blue: 102 / 255
          ),
        ])
      )
    }
    .enableInjection()
  }
}

import SwiftData
import SwiftUI

struct ContentView: View {
  @Environment(\.modelContext) private var modelContext
  @Query(sort: \UserData.name) private var users: [UserData]
  #if DEBUG
    @ObserveInjection var forceRedraw
  #endif
  var body: some View {
    let _ = forceRedraw
    NavigationStack {
      List {
        ForEach(users) { user in
          VStack(alignment: .leading, spacing: 4) {
            Text(user.name)
              .font(.headline)
          }
        }
      }
      .navigationTitle("Emlio")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button("添加示例") {
            addSampleUser()
          }
        }
      }
    }.enableInjection()
  }

  private func addSampleUser() {
    let new = UserData(
      id: Int(Date().timeIntervalSince1970),
      name: "User name",
    )
    modelContext.insert(new)
  }
}
#Preview {
  ContentView()
    .modelContainer(for: UserData.self, inMemory: true)
}

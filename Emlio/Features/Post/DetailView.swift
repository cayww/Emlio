import SwiftData
import SwiftUI

struct DetailView: View {
  #if DEBUG
    @ObserveInjection var forceRedraw
  #endif
  var postItem: PostData
  @EnvironmentObject var router: NavigationRouter
  @Query private var following: [FollowData]
  @EnvironmentObject private var appState: AppState
  @Environment(\.modelContext) private var modelContext
  init(postItem: PostData) {
    self.postItem = postItem
    let userID = postItem.user.id
    _following = Query(filter: #Predicate { $0.toUser.id == userID })
  }
  var followingUserIDs: Set<UUID> {
    Set(following.map { $0.fromUser.id })
  }
  var body: some View {
    #if DEBUG
      let _ = forceRedraw
    #endif
    VStack {
      Spacer().frame(height: 15)
      postItem.postImage
        .resizable()
        .scaledToFill()
        .frame(width: .infinity, height: 440)
        .cornerRadius(20)
      Spacer().frame(height: 20)
      Text(postItem.content)
        .foregroundColor(.white.opacity(0.7))
        .font(.system(size: 18))
        .frame(maxWidth: .infinity, alignment: .leading)
      Spacer().frame(height: 30)
      Text("Replicated jewelry")
        .foregroundColor(Color(red: 254 / 255, green: 13 / 255, blue: 231 / 255))
        .font(.system(size: 16))
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding(.horizontal, 16)
    .frame(maxHeight: .infinity)
    .background(DefaultBackground())
    .navigationBarBackButtonHidden(true)
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        HStack {
          Button {
            router.path.removeLast()
          } label: {
            Image("Assets/emlio_back")
              .resizable()
              .renderingMode(.template)
              .scaledToFit()
              .frame(width: 40, height: 40)
              .foregroundColor(.white)
          }
          postItem.user.photoImage
            .resizable()
            .scaledToFill()
            .frame(width: 39, height: 39)
            .clipShape(Circle())
            .overlay(
              Circle().stroke(
                Color(red: 254 / 255, green: 13 / 255, blue: 231 / 255),
                lineWidth: 1
              )
            )
          Text("\(postItem.user.name)")
            .font(.system(size: 15, design: .default))
            .foregroundColor(.white)
            .lineLimit(1)
        }
      }
      if appState.currentUser?.id != postItem.user.id {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
          if !followingUserIDs.contains(appState.currentUser!.id) {
            Image(systemName: "plus")
              .resizable()
              .scaledToFit()
              .frame(width: 12, height: 12)
              .foregroundColor(.white)
              .frame(width: 48, height: 24)
              .background(
                Capsule()
                  .fill(Color(red: 254 / 255, green: 13 / 255, blue: 231 / 255))
              )
              .onTapGesture {
                do {
                  let descriptor = FetchDescriptor<FollowData>()
                  let results = try modelContext.fetch(descriptor)
                  let resultsArray = Array(results)
                  for result in resultsArray {
                    print(result.toUser.id)
                    print(result.fromUser.id)
                  }
                  let followData = FollowData(
                    fromUser: appState.currentUser!,
                    toUser: postItem.user
                  )
                  modelContext.insert(followData)
                  try modelContext.save()
                } catch {
                  print(" \(error)")
                }
              }
          }

          Image("Assets/emlio_report_icon")
            .resizable()
            .scaledToFit()
            .frame(width: 40, height: 40)
        }
      }
    }
    .enableInjection()
  }
}

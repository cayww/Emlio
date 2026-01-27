import SwiftData
import SwiftUI

struct FollowView: View {
  #if DEBUG
    @ObserveInjection var forceRedraw
  #endif
  @EnvironmentObject var router: NavigationRouter
  @EnvironmentObject private var appState: AppState
  @Environment(\.modelContext) private var modelContext
  @Query private var following: [FollowData]

  var currentUserFollowing: [FollowData] {
    following.filter {
      $0.fromUser.id == appState.currentUser!.id
    }
  }

  var body: some View {
    #if DEBUG
      let _ = forceRedraw
    #endif
    VStack {
      Spacer().frame(height: 35).frame(maxWidth: .infinity)
      if currentUserFollowing.isEmpty {
        Empty()
          .frame(maxHeight: .infinity, alignment: .center)
          .frame(maxWidth: .infinity, alignment: .center)
      } else {
        ScrollView {
          VStack(spacing: 30) {
            ForEach(currentUserFollowing) { follow in
              HStack(spacing: 0) {
                follow.toUser.photoImage
                  .resizable()
                  .scaledToFill()
                  .frame(width: 46, height: 46)
                  .clipShape(Circle())
                  .overlay(
                    Circle().stroke(
                      Color(red: 254 / 255, green: 13 / 255, blue: 231 / 255),
                      lineWidth: 1
                    )
                  )
                  .padding(.trailing, 12)
                Text(follow.toUser.name)
                  .font(.system(size: 20, weight: .bold))
                  .foregroundColor(.white)
                  .padding(.bottom, 10)
                  .padding(.top, 10)
                Spacer()
                Image(systemName: "minus")
                  .foregroundColor(
                    Color(
                      red: 254 / 255,
                      green: 13 / 255,
                      blue: 231 / 255
                    )
                  )
                  .padding(.horizontal, 18)
                  .padding(.vertical, 12)
                  .background(.white)
                  .cornerRadius(100)
                  .onTapGesture {
                    modelContext.delete(follow)
                    try? modelContext.save()
                  }
              }
            }
          }
        }
        .scrollIndicators(.hidden)
      }
    }
    .padding(.horizontal, 16)
    .background(DefaultBackground())
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
            .foregroundColor(.white)
        }
      }
      ToolbarItem(placement: .principal) {
        Text("Followed")
          .foregroundColor(.white)
          .font(.system(size: 20, weight: .bold))
      }
    }
    .enableInjection()
  }
}

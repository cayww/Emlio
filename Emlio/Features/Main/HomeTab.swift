import SwiftData
import SwiftUI

struct HomeTab: View {
  #if DEBUG
    @ObserveInjection var forceRedraw
  #endif
  var currentID: Int
  @Query(sort: \PostData.createdAt, order: .forward) private var posts: [PostData]
  @EnvironmentObject var appState: AppState
  @Query private var following: [FollowData]
  @Query private var users: [UserData]
  @Query private var blocklist: [BlockData]

  init(currentID: Int) {
    self.currentID = currentID
    _following = Query(filter: #Predicate { $0.fromUser.id == currentID })
    _blocklist = Query(
      filter: #Predicate { $0.fromUser.id == currentID }
    )
    _users = Query(
      filter: #Predicate { $0.id != currentID }
    )
  }

  var filteredUsers: [UserData] {
    let blockedIDs = Set(blocklist.map { $0.toUser.id })
    return users.filter { !blockedIDs.contains($0.id) }
  }

  var followingUserIDs: Set<Int> {
    Set(following.map { $0.toUser.id })
  }

  var body: some View {
    let _ = forceRedraw
    GeometryReader { geo in
      VStack(alignment: .leading, spacing: .zero) {
        Spacer().frame(height: 12)
        HStack {
          Image("Assets/emlio_home_emlio")
            .resizable()
            .scaledToFit()
            .frame(
              width: 88, height: 50, alignment: .center)
          Spacer()
          HStack {
            Image("Assets/emlio_home_ai")
              .resizable()
              .scaledToFit()
              .frame(
                width: 32, height: 32, alignment: .center
              )

            Text("Jewelry AI")
              .foregroundColor(.white)
              .font(.system(size: 13, weight: .bold, design: .default))
          }
          .frame(width: 124, height: 44)
          .background(
            LinearGradient(
              colors: [
                Color(red: 1.0, green: 0.341, blue: 0.973),
                Color(red: 0.408, green: 0.655, blue: 1.0),
              ], startPoint: .top, endPoint: .bottom
            )
          )
          .cornerRadius(100)
        }
        Spacer().frame(height: 20)
        ScrollView(.vertical) {
          VStack(alignment: .leading, spacing: .zero) {
            Text("For U")
              .foregroundColor(.white)
              .font(.system(size: 20, weight: .bold, design: .default))
            Spacer().frame(height: 22)
            ScrollView(.horizontal, showsIndicators: false) {
              HStack(spacing: 22) {
                ForEach(posts, id: \.id) { post in
                  VStack(spacing: 0) {
                    ZStack {
                      post.postImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 190, height: 210)
                        .cornerRadius(8)
                      if post.user.id != appState.currentUser!.id {
                        VStack {
                          HStack {
                            Spacer()
                            Image("Assets/emlio_report_icon")
                              .resizable()
                              .scaledToFit()
                              .frame(width: 24, height: 24)
                          }
                          Spacer()
                        }
                        .padding(8)
                      }
                      VStack(spacing: 0) {
                        Spacer()
                        Text(post.content)
                          .lineLimit(2)
                          .truncationMode(.tail)
                          .foregroundColor(.white)
                          .font(.system(size: 11))
                          .padding(.horizontal, 10)
                          .padding(.top, 24)
                          .padding(.bottom, 10)
                          .frame(maxWidth: .infinity, alignment: .leading)
                          .background(
                            LinearGradient(
                              colors: [
                                Color.black.opacity(0),
                                Color.black.opacity(0.5),
                              ],
                              startPoint: .top,
                              endPoint: .bottom
                            )
                          )
                          .clipShape(
                            .rect(
                              bottomLeadingRadius: 8,
                              bottomTrailingRadius: 8
                            )
                          )
                      }
                    }
                    .frame(width: 190, height: 210)
                    Spacer().frame(height: 10)
                    HStack(spacing: 0) {
                      post.user.photoImage
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .overlay(
                          Circle().stroke(
                            Color(red: 254 / 255, green: 13 / 255, blue: 231 / 255),
                            lineWidth: 1
                          )
                        )
                        .padding(.trailing, 10)
                      Text(post.user.name)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .foregroundColor(.white)
                        .font(.system(size: 15, weight: .medium, design: .default))
                    }.frame(maxWidth: .infinity, alignment: .leading)
                  }
                  .padding(10)
                  .background(.white.opacity(0.1))
                  .cornerRadius(20)
                }
              }
            }
            Spacer().frame(height: 20)
            Text("Hot User")
              .foregroundColor(.white)
              .font(.system(size: 20, weight: .bold, design: .default))
            Spacer().frame(height: 12)
            ScrollView(.horizontal, showsIndicators: false) {
              HStack(spacing: 12) {
                ForEach(filteredUsers, id: \.id) { user in
                  let isFollowing = followingUserIDs.contains(user.id)
                  ZStack(alignment: .top) {
                    user.photoImage
                      .resizable()
                      .scaledToFill()
                      .frame(width: 60, height: 60)
                      .clipShape(Circle())
                      .overlay(
                        Circle().stroke(
                          Color(red: 254 / 255, green: 13 / 255, blue: 231 / 255),
                          lineWidth: 1
                        )
                      )
                      .overlay(
                        Capsule()
                          .fill(Color(red: 254 / 255, green: 13 / 255, blue: 231 / 255))
                          .frame(width: 24, height: 12)
                          .overlay(
                            Image(systemName: !isFollowing ? "plus" : "checkmark")
                              .foregroundColor(.white)
                              .font(.system(size: 6, weight: .bold))
                          )

                          .offset(y: 6),
                        alignment: .bottom
                      )
                    VStack(spacing: 0) {
                      Spacer()
                      Text("\(user.name)")
                        .font(.system(size: 13, design: .default))
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .frame(width: 72, height: 60, alignment: .bottom)
                        .padding(.bottom, 6)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(20)
                    }
                  }
                  .frame(width: 72, height: 90, alignment: .top)
                }
              }
            }
            Spacer().frame(height: 24)
            Text("Nail Art Moments")
              .foregroundColor(.white)
              .font(.system(size: 20, weight: .bold, design: .default))
            Spacer().frame(height: 12)
          }
        }
      }
      .padding(.horizontal, 16)
      .background(DefaultBackground())
      .enableInjection()
    }
  }
}

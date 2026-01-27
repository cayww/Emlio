import SwiftData
import SwiftUI

struct ProfileTab: View {
  #if DEBUG
    @ObserveInjection var forceRedraw
  #endif
  var currentID: UUID
  @EnvironmentObject var router: NavigationRouter
  @EnvironmentObject private var appState: AppState
  @Query private var posts: [PostData]
  @Query private var followings: [FollowData]
  init(currentID: UUID) {
    self.currentID = currentID
    _posts = Query(
      filter: #Predicate { $0.user.id == currentID }
    )
  }
  let columns = [
    GridItem(.flexible(), spacing: 13),
    GridItem(.flexible(), spacing: 13),
  ]
  var body: some View {
    #if DEBUG
      let _ = forceRedraw
    #endif

    VStack(spacing: 0) {
      Spacer().frame(height: 12)
      Image("Assets/emlio_setting_icon")
        .resizable()
        .scaledToFit()
        .frame(width: 40, height: 40)
        .onTapGesture {
          router.path.append(MainRoute.setting)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
      Spacer().frame(height: 30)
      appState.currentUser!.photoImage
        .resizable()
        .scaledToFill()
        .frame(width: 115, height: 115)
        .clipShape(Circle())
        .overlay(
          Circle().stroke(
            Color(red: 254 / 255, green: 13 / 255, blue: 231 / 255),
            lineWidth: 1
          )
        )
        .overlay(
          Image(systemName: "camera.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 24, height: 24)
            .foregroundColor(.white)
            .frame(width: 34, height: 34)
            .background(
              Color(
                red: 254 / 255,
                green: 13 / 255,
                blue: 231 / 255
              )
            )
            .clipShape(Circle()), alignment: .bottomTrailing
        )
        .onTapGesture {
          router.path.append(MainRoute.editProfile)
        }
      Spacer().frame(height: 16)
      Text(appState.currentUser!.name)
        .foregroundColor(.white)
        .font(.system(size: 28, weight: .bold))
      Spacer().frame(height: 8)
      HStack {
        Spacer()
        VStack(spacing: 3) {
          Text("\(followings.count)")
            .foregroundColor(.white)
            .font(.system(size: 20, weight: .bold))
          Text("Followed")
            .foregroundColor(.white.opacity(0.5))
            .font(.system(size: 11, weight: .medium))
        }
        .frame(width: 50)
        .onTapGesture {
          router.path.append(MainRoute.following)
        }
        Spacer()
        Divider()
          .frame(height: 30)
          .background(Color.white.opacity(0.5))
        Spacer()
        VStack(spacing: 3) {
          Text("0")
            .foregroundColor(.white)
            .font(.system(size: 20, weight: .bold))
          Text("Fans")
            .foregroundColor(.white.opacity(0.5))
            .font(.system(size: 11, weight: .medium))
        }
        .frame(width: 50)
        .onTapGesture {
          router.path.append(MainRoute.follower)
        }
        Spacer()
      }
      .frame(width: 275, height: 56)
      .background(.white.opacity(0.1))
      .cornerRadius(20)
      Spacer().frame(height: 24)
      HStack(spacing: 13) {
        Button(action: {
          router.path.append(MainRoute.wallet)
        }) {
          HStack(spacing: 8) {
            Image("Assets/emlio_wallet_p_icon")
              .resizable()
              .scaledToFit()
              .frame(width: 20, height: 20)
            Text("Wallet")
              .foregroundColor(.black)
              .font(.system(size: 18, weight: .bold))
          }
          .padding(.vertical, 14)
        }
        .frame(maxWidth: .infinity)
        .background(
          LinearGradient(
            colors: [
              Color(red: 255 / 255, green: 229 / 255, blue: 214 / 255),
              Color(red: 253 / 255, green: 147 / 255, blue: 232 / 255),
            ],
            startPoint: .leading,
            endPoint: .trailing
          )
        )
        .cornerRadius(100)
        Button(action: {
          router.path.append(MainRoute.message(currentID: appState.currentUser!.id))
        }) {
          HStack(spacing: 8) {
            Image("Assets/emlio_msg_p_icon")
              .resizable()
              .scaledToFit()
              .frame(width: 20, height: 20)
            Text("Message")
              .foregroundColor(.white)
              .font(.system(size: 18, weight: .bold))
          }
          .padding(.vertical, 14)
        }
        .frame(maxWidth: .infinity)
        .background(
          LinearGradient(
            colors: [
              Color(red: 255 / 255, green: 87 / 255, blue: 249 / 255),
              Color(red: 104 / 255, green: 167 / 255, blue: 255 / 255),
            ],
            startPoint: .top,
            endPoint: .bottom
          )
        )
        .cornerRadius(100)
      }
      Spacer().frame(height: 13)
      ScrollView {
        VStack(alignment: .leading, spacing: 16) {
          Spacer().frame(height: 4)
          Text("Moments")
            .foregroundColor(.white)
            .font(.system(size: 20, weight: .bold))
          LazyVGrid(columns: columns, spacing: 16) {
            ForEach(posts, id: \.id) { post in
              ZStack {
                VStack(spacing: 0) {
                  post.postImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: .infinity, height: 190)
                    .cornerRadius(8)
                    .frame(width: .infinity, height: 190)
                  Spacer().frame(height: 63)
                }
                VStack(spacing: 0) {
                  Spacer().frame(height: 145)
                  post.user.photoImage
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
                  Spacer().frame(height: 6)
                  Text("\(post.user.name)")
                    .font(.system(size: 15, design: .default))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .frame(width: .infinity)
                }
              }
              .background(.white.opacity(0.1))
              .cornerRadius(20)
              .onTapGesture {
                router.path.append(MainRoute.postDetail(postItem: post))
              }
            }
          }
        }
      }
      .scrollIndicators(.hidden)
      .scrollBounceBehavior(.basedOnSize)
    }
    .padding(.horizontal, 16)
    .background(DefaultBackground())
    .enableInjection()
  }
}

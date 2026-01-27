import SwiftData
import SwiftUI

struct OtherProfileView: View {
  #if DEBUG
    @ObserveInjection var forceRedraw
  #endif
  private var otherUser: UserData
  @EnvironmentObject private var appState: AppState
  @EnvironmentObject var router: NavigationRouter
  @Query private var fans: [FollowData]
  @State private var chatID: String = ""
  @Query private var posts: [PostData]
  @State private var followData: FollowData?
  @Environment(\.modelContext) private var modelContext
  init(otherUser: UserData) {
    self.otherUser = otherUser
    let otherUserID = otherUser.id
    _fans = Query(filter: #Predicate { $0.toUser.id == otherUserID })
    _posts = Query(
      filter: #Predicate { $0.user.id == otherUserID }
    )
  }

  var body: some View {
    #if DEBUG
      let _ = forceRedraw
    #endif
    VStack {
      Spacer().frame(height: 23)
      otherUser.photoImage
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
      Spacer().frame(height: 16)
      Text(otherUser.name)
        .foregroundColor(.white)
        .font(.system(size: 28, weight: .bold))
      Spacer().frame(height: 8)
      HStack {
        Spacer()
        VStack(spacing: 3) {
          Text("0")
            .foregroundColor(.white)
            .font(.system(size: 20, weight: .bold))
          Text("Followed")
            .foregroundColor(.white.opacity(0.5))
            .font(.system(size: 11, weight: .medium))
        }
        .frame(width: 50)
        Spacer()
        Divider()
          .frame(height: 30)
          .background(Color.white.opacity(0.5))
        Spacer()
        VStack(spacing: 3) {
          Text("\(fans.count)")
            .foregroundColor(.white)
            .font(.system(size: 20, weight: .bold))
          Text("Fans")
            .foregroundColor(.white.opacity(0.5))
            .font(.system(size: 11, weight: .medium))
        }
        .frame(width: 50)
        Spacer()
      }
      .frame(width: 275, height: 56)
      .background(.white.opacity(0.1))
      .cornerRadius(20)
      Spacer().frame(height: 24)
      HStack(spacing: 13) {
        Button {
          if let follow = followData {
            modelContext.delete(follow)
            try? modelContext.save()
            followData = nil
          } else {
            let newFollow = FollowData(
              fromUser: appState.currentUser!,
              toUser: otherUser
            )
            modelContext.insert(newFollow)
            try? modelContext.save()
            followData = newFollow
          }
        } label: {
          Text(followData != nil ? "- Followed" : "+ Follow")
            .foregroundColor(
              followData == nil ? .white : Color(red: 254 / 255, green: 13 / 255, blue: 231 / 255)
            )
            .font(.system(size: 18, weight: .bold))
            .padding(.vertical, 14)
            .frame(maxWidth: .infinity)
            .background(
              followData == nil ? Color(red: 254 / 255, green: 13 / 255, blue: 231 / 255) : .white
            )
            .cornerRadius(100)
        }
        .task {
          let currentUserID = appState.currentUser!.id
          let otherUserID = otherUser.id
          let descriptor = FetchDescriptor<FollowData>(
            predicate: #Predicate { $0.fromUser.id == currentUserID && $0.toUser.id == otherUserID }
          )
          try? followData = modelContext.fetch(descriptor).first
        }
        Button(action: {
          guard !chatID.isEmpty else {
            return
          }
          router.path.append(MainRoute.chat(otherUser: otherUser, chatID: chatID))
        }) {
          HStack(spacing: 8) {
            Image("Assets/emlio_msg_p_icon")
              .resizable()
              .scaledToFit()
              .frame(width: 20, height: 20)
            Text("Chat")
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
          LazyVGrid(
            columns: [
              GridItem(.flexible(), spacing: 13),
              GridItem(.flexible(), spacing: 13),
            ], spacing: 16
          ) {
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
      ToolbarItem(placement: .navigationBarTrailing) {
        Image("Assets/emlio_report_icon")
          .resizable()
          .scaledToFit()
          .frame(width: 40, height: 40)
      }
    }
    .onAppear {
      chatID = ChatRoomData.makeRoomId(userA: appState.currentUser!.id, userB: otherUser.id)
      Task {
        let chatRoom = try? modelContext.fetch(
          FetchDescriptor<ChatRoomData>(
            predicate: #Predicate {
              $0.id == chatID
            })
        ).first
        if chatRoom == nil {
          let chatRoomT = ChatRoomData(
            id: chatID, firstUser: appState.currentUser!, secondUser: otherUser)
          modelContext.insert(chatRoomT)
          try? modelContext.save()
        }
      }
    }
    .enableInjection()
  }
}

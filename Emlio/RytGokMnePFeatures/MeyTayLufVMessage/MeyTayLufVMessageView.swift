import Foundation
import SwiftData
import SwiftUI

struct MessageView: View {

  var currentID: UUID
  @EnvironmentObject var router: NavigationRouter
  @EnvironmentObject private var appState: AppState
  @Query private var following: [FollowData]
  @Query private var blocklist: [BlockData]
  @Query private var chats: [ChatRoomData]

  init(currentID: UUID) {
    self.currentID = currentID
    _following = Query(filter: #Predicate { $0.fromUser.id == currentID })
    _blocklist = Query(
      filter: #Predicate { $0.fromUser.id == currentID }
    )
    _chats = Query(filter: #Predicate { $0.firstUser.id == currentID && $0.lastMessage != nil })
  }

  var filteredChats: [ChatRoomData] {
    chats.filter { chat in
      !blocklist.contains(where: { $0.toUser.id == chat.secondUser.id })
    }
  }

  func timeAgo(from date: Date) -> String {
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .abbreviated  // "1 min ago" / "2 h ago"
    return formatter.localizedString(for: date, relativeTo: Date())
  }
  var body: some View {

    VStack(alignment: .leading, spacing: 0) {
      Spacer().frame(height: 30)
      if !following.isEmpty {
        Text("Followed")
          .font(.system(size: 18, weight: .bold))
          .foregroundColor(.white)
        Spacer().frame(height: 20)
      }
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 12) {
          ForEach(following, id: \.id) { followingItem in
            VStack(spacing: 8) {
              followingItem.toUser.photoImage
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
              Text("\(followingItem.toUser.name)")
                .font(.system(size: 13, design: .default))
                .foregroundColor(.white)
                .lineLimit(1)
                .frame(width: 58)
            }
          }
        }
      }
      Spacer().frame(height: 20)
      if filteredChats.isEmpty {
        Empty()
          .frame(maxHeight: .infinity, alignment: .center)
          .frame(maxWidth: .infinity, alignment: .center)
      } else {
        ScrollView {
          VStack(spacing: 30) {
            ForEach(filteredChats, id: \.id) { chat in
              HStack(alignment: .top, spacing: 12) {
                chat.secondUser.photoImage
                  .resizable()
                  .scaledToFill()
                  .frame(width: 44, height: 44)
                  .clipShape(Circle())
                VStack(alignment: .leading, spacing: 6) {
                  HStack {
                    Text(chat.secondUser.name)
                      .foregroundColor(.white)
                      .font(.system(size: 15, weight: .bold))
                    Spacer()
                    Text(timeAgo(from: chat.lastMessageAt ?? Date()))
                      .foregroundColor(.white.opacity(0.5))
                      .font(.system(size: 11, weight: .regular))
                  }
                  .frame(maxWidth: .infinity)
                  Text(chat.lastMessage ?? "")
                    .lineLimit(1)
                    .foregroundColor(.white.opacity(0.5))
                    .font(.system(size: 13, weight: .regular))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
              }
              .onTapGesture {
                router.path.append(MainRoute.chat(otherUser: chat.secondUser, chatID: chat.id))
              }
            }
          }
        }
        .scrollIndicators(.hidden)
        .scrollBounceBehavior(.basedOnSize)
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
        Text("Message")
          .foregroundColor(.white)
          .font(.system(size: 20, weight: .bold))
      }
    }

  }
}

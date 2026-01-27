import SwiftData
import SwiftUI

struct ChatView: View {
  #if DEBUG
    @ObserveInjection var forceRedraw
  #endif
  private var otherUser: UserData
  private var chatID: String
  @EnvironmentObject var router: NavigationRouter
  @EnvironmentObject private var appState: AppState
  @State private var chatRoomData: ChatRoomData?
  @Query private var chatMessages: [ChatMessageData]
  @Environment(\.modelContext) private var modelContext
  @State private var commentText: String = ""
  init(otherUser: UserData, chatID: String) {
    self.otherUser = otherUser
    self.chatID = chatID
    _chatMessages = Query(filter: #Predicate { $0.room.id == chatID })
  }

  var body: some View {
    #if DEBUG
      let _ = forceRedraw
    #endif
    VStack {
      Spacer().frame(height: 35).frame(maxWidth: .infinity)
      ScrollView {
        VStack(alignment: .trailing, spacing: 30) {
          ForEach(chatMessages, id: \.id) { message in
            HStack(alignment: .top, spacing: 0) {
              Text(message.content)
                .foregroundColor(
                  .white
                )
                .font(.system(size: 15, weight: .medium))
                .padding(12)
                .background(
                  Color(
                    red: 254 / 255,
                    green: 13 / 255,
                    blue: 231 / 255
                  )
                )
                .cornerRadius(20)
                .padding(.leading, 50)
                .padding(.horizontal, 16)
                .frame(maxWidth: .infinity, alignment: .trailing)
              appState.currentUser!.photoImage
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            }
            .frame(maxWidth: .infinity)
          }
        }
      }
    }
    .padding(.horizontal, 16)
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
          otherUser.photoImage
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
          Text(otherUser.name)
            .font(.system(size: 15))
            .foregroundColor(.white)
            .lineLimit(1)
        }
      }
      ToolbarItem(placement: .navigationBarTrailing) {
        Image("Assets/emlio_report_icon")
          .resizable()
          .scaledToFit()
          .frame(width: 40, height: 40)
      }
    }
    .safeAreaInset(edge: .bottom) {
      TextField(
        "", text: $commentText,
        prompt: Text("Add Comment")
          .foregroundColor(.gray)
          .font(.system(size: 13, weight: .regular)),
      )
      .submitLabel(.done)
      .foregroundColor(.white)
      .padding(.horizontal, 16)
      .padding(.trailing, 50)
      .frame(height: 40)
      .background(Color(red: 97 / 255, green: 95 / 255, blue: 102 / 255))
      .cornerRadius(20)
      .overlay(
        Image("Assets/emlio_send_icon")
          .resizable()
          .scaledToFit()
          .frame(width: 60, height: 40)
          .onTapGesture {
            print(chatRoomData!.secondUser.name)
            guard !commentText.isEmpty else { return }
            guard chatRoomData != nil else { return }
            let newMessage = ChatMessageData(
              content: commentText,
              room: chatRoomData!,
            )
            modelContext.insert(newMessage)
            try? modelContext.save()
            chatRoomData?.lastMessage = commentText
            chatRoomData?.lastMessageAt = Date()
            commentText = ""
          }, alignment: .trailing
      )
      .padding(.horizontal, 10)
      .padding(.top, 6)
      .background(
        Color.black
          .ignoresSafeArea(edges: .bottom)
      )
    }
    .onAppear {
      chatRoomData = try? modelContext.fetch(
        FetchDescriptor<ChatRoomData>(
          predicate: #Predicate {
            $0.id == chatID
          })
      ).first
    }
    .enableInjection()
  }
}

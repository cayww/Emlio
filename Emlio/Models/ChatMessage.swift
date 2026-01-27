import Foundation
import SwiftData

@Model
final class ChatMessageData {
  @Attribute(.unique) var id: UUID = UUID()
  var content: String
  var room: ChatRoomData

  init(
    content: String,
    room: ChatRoomData,
  ) {
    self.content = content
    self.room = room
  }
}

import Foundation
import SwiftData

@Model
final class ChatRoomData {

  @Attribute(.unique)
  var id: String

  var firstUser: UserData

  var secondUser: UserData

  var lastMessage: String?

  var lastMessageAt: Date?

  init(
    id: String,
    firstUser: UserData,
    secondUser: UserData
  ) {
    self.id = id
    self.firstUser = firstUser
    self.secondUser = secondUser
  }

  static func makeRoomId(userA: UUID, userB: UUID) -> String {
    [userA.uuidString, userB.uuidString].sorted().joined(separator: "_")
  }
}

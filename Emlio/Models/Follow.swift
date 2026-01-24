import SwiftData
import SwiftUI

@Model
class FollowData {
  @Attribute(.unique) var id: UUID = UUID()
  var fromUser: UserData
  var toUser: UserData
  var createdAt: Date

  init(fromUser: UserData, toUser: UserData, createdAt: Date = .now) {
    self.fromUser = fromUser
    self.toUser = toUser
    self.createdAt = createdAt
  }
}

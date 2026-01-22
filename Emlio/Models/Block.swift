import SwiftData
import SwiftUI

@Model
class BlockData {
  @Attribute(.unique) var id: Int
  var fromUser: UserData
  var toUser: UserData
  var createdAt: Date

  init(id: Int = 0, fromUser: UserData, toUser: UserData, createdAt: Date = .now) {
    self.id = id
    self.fromUser = fromUser
    self.toUser = toUser
    self.createdAt = createdAt
  }
}

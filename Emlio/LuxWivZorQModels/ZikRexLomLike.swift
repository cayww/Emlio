import SwiftData
import SwiftUI

@Model
class PostLikeData {
  @Attribute(.unique) var id: UUID = UUID()
  var user: UserData
  var post: PostData
  init(user: UserData, post: PostData) {
    self.user = user
    self.post = post
  }
}

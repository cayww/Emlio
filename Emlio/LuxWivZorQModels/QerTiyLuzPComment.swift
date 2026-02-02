import SwiftData
import SwiftUI

@Model
class CommentData {
  @Attribute(.unique) var id: UUID = UUID()
  var user: UserData
  var post: PostData
  var content: String
  init(user: UserData, post: PostData, content: String) {
    self.user = user
    self.post = post
    self.content = content
  }
}

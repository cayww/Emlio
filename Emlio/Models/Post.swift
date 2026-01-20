import SwiftData
import SwiftUI

@Model
class PostData {

  @Attribute(.unique) var id: Int
  var userId: Int
  var content: String
  var image: String
  var createdAt: Date

  init(
    id: Int = 0,
    userId: Int,
    content: String,
    image: String,
    createdAt: Date = .now
  ) {
    self.id = id
    self.userId = userId
    self.content = content
    self.image = image
    self.createdAt = createdAt
  }

  var imageURL: URL? {
    let fileManager = FileManager.default

    if fileManager.fileExists(atPath: image) {
      return URL(fileURLWithPath: image)
    }

    if let url = Bundle.main.url(
      forResource: image, withExtension: nil, subdirectory: "Resources/AppAssets/Images")
    {
      return url
    }

    return nil
  }

  var postImage: Image {
    if let url = imageURL,
      let uiImage = UIImage(contentsOfFile: url.path)
    {
      return Image(uiImage: uiImage)
    } else {
      return Image(systemName: "photo")
    }
  }
}

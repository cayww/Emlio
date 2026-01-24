import SwiftData
import SwiftUI

@Model
class PostData {

  @Attribute(.unique) var id: UUID = UUID()
  var content: String
  var image: String
  var createdAt: Date
  var user: UserData

  init(
    user: UserData,
    content: String,
    image: String,
    createdAt: Date = .now
  ) {
    self.user = user
    self.content = content
    self.image = image
    self.createdAt = createdAt
  }

  var imageURL: URL? {
    let fileManager = FileManager.default

    if fileManager.fileExists(atPath: image) {
      return URL(fileURLWithPath: image)
    }

    if let resourcePath = Bundle.main.resourcePath {
      let resourceURL = URL(fileURLWithPath: resourcePath)
      let potentialURL = resourceURL.appendingPathComponent(image)
      if fileManager.fileExists(atPath: potentialURL.path) {
        return potentialURL
      }
    }

    let name = (image as NSString).deletingPathExtension
    let ext = (image as NSString).pathExtension
    if let url = Bundle.main.url(forResource: name, withExtension: ext) {
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
      return Image(systemName: "image")
    }
  }
}

struct PostDTO: Decodable {
  let id: Int
  let userId: Int
  let content: String
  let image: String
  let createdAt: Date
}

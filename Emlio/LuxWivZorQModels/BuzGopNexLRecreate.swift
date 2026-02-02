import SwiftData
import SwiftUI

@Model
class RecreateData {
  @Attribute(.unique) var id: UUID = UUID()
  var user: UserData
  var post: PostData
  var image: String
  init(user: UserData, post: PostData, image: String) {
    self.user = user
    self.post = post
    self.image = image
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

  var imageImage: Image {
    if let url = imageURL,
      let uiImage = UIImage(contentsOfFile: url.path)
    {
      return Image(uiImage: uiImage)
    } else {
      return Image(systemName: "image")
    }
  }
}

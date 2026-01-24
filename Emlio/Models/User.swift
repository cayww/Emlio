import Foundation
import SwiftData
import SwiftUI

@Model
class UserData {
  @Attribute(.unique) var id: UUID = UUID()
  var name: String
  var email: String
  var coin: Int
  var photo: String
  var password: String

  @Relationship(deleteRule: .cascade, inverse: \PostData.user)
  var posts: [PostData] = []

  init(
    name: String,
    email: String,
    coin: Int = 0,
    photo: String = "emlio_default_photo.png",
    password: String = "123456789"
  ) {
    self.name = name
    self.email = email
    self.coin = coin
    self.photo = photo
    self.password = password
  }

  var photoURL: URL? {
    let fileManager = FileManager.default

    if fileManager.fileExists(atPath: photo) {
      return URL(fileURLWithPath: photo)
    }

    if let resourcePath = Bundle.main.resourcePath {
      let resourceURL = URL(fileURLWithPath: resourcePath)
      let potentialURL = resourceURL.appendingPathComponent(photo)
      if fileManager.fileExists(atPath: potentialURL.path) {
        return potentialURL
      }
    }

    let name = (photo as NSString).deletingPathExtension
    let ext = (photo as NSString).pathExtension
    if let url = Bundle.main.url(forResource: name, withExtension: ext) {
      return url
    }

    return nil
  }

  var photoImage: Image {
    if let url = photoURL,
      let uiImage = UIImage(contentsOfFile: url.path)
    {
      return Image(uiImage: uiImage)
    } else {
      return Image(systemName: "person.fill")
    }
  }
}

struct UserDTO: Decodable {
  let id: Int
  let name: String
  let email: String
  let coin: Int
  let photo: String
  let password: String
}

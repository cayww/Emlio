import Foundation
import SwiftData
import SwiftUI

@Model
class UserData {
  @Attribute(.unique) var id: Int
  var name: String
  var email: String
  var coin: Int
  var photo: String
  var password: String

  init(
    id: Int = 0,
    name: String,
    email: String,
    coin: Int = 0,
    photo: String = "emlio_default_photo.png",
    password: String = "123456789"
  ) {
    self.id = id
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

    if let url = Bundle.main.url(
      forResource: photo, withExtension: nil, subdirectory: "Resources/AppAssets/Images")
    {
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

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
    Bundle.main.url(
      forResource: photo.replacingOccurrences(of: ".png", with: ""),
      withExtension: "png",
      subdirectory: "Resources/AppAssets/Images"
    )
  }

  var photoImage: Image {
    if let url = photoURL, let uiImage = UIImage(contentsOfFile: url.path) {
      return Image(uiImage: uiImage)
    } else {
      return Image(systemName: "person.fill")
    }
  }
}

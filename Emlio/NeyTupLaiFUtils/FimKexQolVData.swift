import SwiftData
import SwiftUI

func bootstrapData(context: ModelContext) throws {

  let usersURL = Bundle.main.url(forResource: "users", withExtension: "json")!
  let usersData = try Data(contentsOf: usersURL)
  let userDTOs = try JSONDecoder().decode([UserDTO].self, from: usersData)

  var userMap: [Int: UserData] = [:]

  for dto in userDTOs {
    let user = UserData(
      name: dto.name,
      email: dto.email,
      coin: dto.coin,
      photo: dto.photo,
      password: dto.password
    )

    context.insert(user)
    userMap[dto.id] = user
  }

  let postsURL = Bundle.main.url(forResource: "posts", withExtension: "json")!
  let postsData = try Data(contentsOf: postsURL)

  let decoder = JSONDecoder()
  decoder.dateDecodingStrategy = .iso8601
  let postDTOs = try decoder.decode([PostDTO].self, from: postsData)

  for dto in postDTOs {
    guard let user = userMap[dto.userId] else { continue }
    let post = PostData(
      user: user,
      content: dto.content,
      image: dto.image,
      createdAt: dto.createdAt
    )

    context.insert(post)
  }

  try context.save()
}

func bootstrapIfNeeded(context: ModelContext) {
  let key = "didBootstrapPostData"
  guard !UserDefaults.standard.bool(forKey: key) else { return }

  do {
    try bootstrapData(context: context)
    UserDefaults.standard.set(true, forKey: key)
  } catch {
  }
}

import SwiftData
import SwiftUI

struct HomeTab: View {
  #if DEBUG
    @ObserveInjection var forceRedraw
  #endif
  @Query(sort: \PostData.createdAt, order: .reverse) private var posts: [PostData]

  var body: some View {
    let _ = forceRedraw
    GeometryReader { geo in
      VStack(alignment: .leading, spacing: .zero) {
        Spacer().frame(height: 12)
        HStack {
          Image("Assets/emlio_home_emlio")
            .resizable()
            .scaledToFit()
            .frame(
              width: 88, height: 50, alignment: .center)
          Spacer()
          HStack {
            Image("Assets/emlio_home_ai")
              .resizable()
              .scaledToFit()
              .frame(
                width: 32, height: 32, alignment: .center
              )

            Text("Jewelry AI")
              .foregroundColor(.white)
              .font(.system(size: 13, weight: .bold, design: .default))
          }
          .frame(width: 124, height: 44)
          .background(
            LinearGradient(
              colors: [
                Color(red: 1.0, green: 0.341, blue: 0.973),
                Color(red: 0.408, green: 0.655, blue: 1.0),
              ], startPoint: .top, endPoint: .bottom
            )
          )
          .cornerRadius(100)
        }
        Spacer().frame(height: 20)
        ScrollView(.vertical) {
          VStack(alignment: .leading, spacing: .zero) {
            Text("For U")
              .foregroundColor(.white)
              .font(.system(size: 20, weight: .bold, design: .default))
            Spacer().frame(height: 22)
            ScrollView(.horizontal, showsIndicators: false) {
              HStack {
                ForEach(posts, id: \.id) { post in
                  post.postImage
                    .resizable()
                    .scaledToFill()
                    .frame(width: 190, height: 210)
                    .cornerRadius(8)
                }
              }
            }
          }
        }
      }
    }
    .padding(.horizontal, 16)
    .background(DefaultBackground())
    .enableInjection()
  }
}

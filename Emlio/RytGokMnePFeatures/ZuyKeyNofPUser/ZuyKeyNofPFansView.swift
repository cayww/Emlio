import SwiftData
import SwiftUI

struct FansView: View {

  @EnvironmentObject var router: NavigationRouter
  var body: some View {

    GeometryReader { geometry in
      VStack {
        Empty()
          .frame(maxHeight: .infinity, alignment: .center)
          .frame(maxWidth: .infinity, alignment: .center)
      }
    }
    .background(DefaultBackground())
    .navigationBarBackButtonHidden(true)
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        Button {
          router.path.removeLast()
        } label: {
          Image("Assets/emlio_back")
            .resizable()
            .renderingMode(.template)
            .scaledToFit()
            .frame(width: 40, height: 40)
            .foregroundColor(.white)
        }
      }
      ToolbarItem(placement: .principal) {
        Text("Fans")
          .foregroundColor(.white)
          .font(.system(size: 20, weight: .bold))
      }
    }

  }
}

import SwiftUI

struct LoginView: View {
  #if DEBUG
    @ObserveInjection var forceRedraw
  #endif
  @EnvironmentObject var router: NavigationRouter
  var body: some View {
    let _ = forceRedraw
    VStack {

    }
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
            .foregroundColor(.black)
        }
      }
      ToolbarItem(placement: .title) {
        Text("Login")
      }
    }
  }
}

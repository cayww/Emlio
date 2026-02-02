import AlertToast
import PhotosUI
import SwiftUI

struct ResultView: View {

  @EnvironmentObject var router: NavigationRouter
  @State private var showToast: Bool = false
  private var aiGen = 1
  init() {
    self.aiGen = Int.random(in: 1...5)
  }
  var body: some View {

    let name = ("ai_gen_\(aiGen).png" as NSString).deletingPathExtension
    let ext = ("ai_gen_\(aiGen).png" as NSString).pathExtension
    let url = Bundle.main.url(forResource: name, withExtension: ext)
    VStack(spacing: 0) {
      Spacer().frame(height: 35)
      Image(uiImage: UIImage(contentsOfFile: url!.path)!)
        .resizable()
        .scaledToFill()
        .frame(width: .infinity, height: 440)
        .clipShape(RoundedRectangle(cornerRadius: 20))
      Spacer().frame(height: 40)
      Button {
        PHPhotoLibrary.requestAuthorization { status in
          if status == .authorized || status == .limited {
            UIImageWriteToSavedPhotosAlbum(UIImage(contentsOfFile: url!.path)!, nil, nil, nil)
            showToast = true
          }
        }
      } label: {
        Text("Save")
          .foregroundColor(.white)
          .font(.system(size: 18, weight: .bold))
          .frame(maxWidth: .infinity)
      }
      .frame(height: 52)
      .background(
        LinearGradient(
          colors: [
            Color(red: 1.0, green: 0.341, blue: 0.973),
            Color(red: 0.408, green: 0.655, blue: 1.0),
          ], startPoint: .top, endPoint: .bottom)
      )
      .clipShape(RoundedRectangle(cornerRadius: 100))
      Spacer()
    }
    .toast(isPresenting: $showToast) {
      AlertToast(type: .complete(.black), title: "Saved to Photos")
    }
    .padding(.horizontal, 16)
    .frame(maxWidth: .infinity)
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
        Text("AI – Jewelry Art Generator")
          .foregroundColor(.white)
          .font(.system(size: 20, weight: .bold))
      }
    }

  }
}

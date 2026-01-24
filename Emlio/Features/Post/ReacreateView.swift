import SwiftData
import SwiftUI

struct ReacreateView: View {
  #if DEBUG
    @ObserveInjection var forceRedraw
  #endif
  let postItem: PostData
  @Environment(\.modelContext) private var modelContext
  @EnvironmentObject private var appState: AppState
  @EnvironmentObject var router: NavigationRouter
  @State private var isLoading = false
  @State private var showPicker = false
  @State private var selectedImage: UIImage?
  var body: some View {
    #if DEBUG
      let _ = forceRedraw
    #endif
    GeometryReader { geo in
      VStack(alignment: .leading, spacing: 0) {
        Spacer().frame(height: 30)
        Text("Show off your jewelry! Share your recreations with us!")
          .font(.system(size: 24, weight: .bold))
          .foregroundStyle(
            LinearGradient(
              colors: [
                Color(red: 255 / 255, green: 229 / 255, blue: 214 / 255),
                Color(red: 253 / 255, green: 147 / 255, blue: 232 / 255),
              ],
              startPoint: .leading,
              endPoint: .trailing
            )
          )
        Spacer().frame(height: 45)
        if let img = selectedImage {
          Image(uiImage: img)
            .resizable()
            .scaledToFill()
            .frame(width: 200, height: 260)
            .cornerRadius(20)
            .onTapGesture {
              showPicker = true
            }
        } else {
          ZStack {
            Image("Assets/emlio_recreate_add")
              .resizable()
              .scaledToFit()
              .frame(width: 40, height: 40)
          }
          .frame(width: 200, height: 260)
          .background(.white.opacity(0.1))
          .cornerRadius(20)
          .onTapGesture {
            showPicker = true
          }
        }
        Spacer()
        Button(action: {
          Task {
            guard !isLoading else {
              return
            }
            guard let img = selectedImage else {
              return
            }
            isLoading = true
            defer { isLoading = false }
            try? await Task.sleep(nanoseconds: 500_000_000)
            if let url = saveImageToDocuments(image: img, prefix: "recreate") {
              let recreate = RecreateData(
                user: appState.currentUser!,
                post: postItem,
                image: url.path,
              )
              do {
                modelContext.insert(recreate)
                try modelContext.save()
              } catch {
                print("保存失败:", error)
              }
              router.path.removeLast()
            }
          }
        }) {
          if isLoading {
            ProgressView()
              .progressViewStyle(CircularProgressViewStyle(tint: .white))
          } else {
            Text("Publish")
              .foregroundColor(.white)
              .bold()
          }
        }
        .buttonStyle(GradientButtonStyle())
      }
      .sheet(isPresented: $showPicker) {
        ImagePicker(image: $selectedImage).ignoresSafeArea()
      }
    }
    .padding(.horizontal, 16)
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
    }
    .enableInjection()
  }
}

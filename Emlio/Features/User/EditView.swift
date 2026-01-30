import SwiftData
import SwiftUI

struct EditView: View {

  @EnvironmentObject var router: NavigationRouter
  @EnvironmentObject private var appState: AppState
  @Environment(\.modelContext) private var modelContext
  @State private var name: String = ""
  @State private var isLoading = false
  @State private var showPicker = false
  @State private var selectedImage: UIImage?
  var body: some View {

    VStack(alignment: .center, spacing: 0) {
      Spacer().frame(height: 20).frame(maxWidth: .infinity)
      if let img = selectedImage {
        Image(uiImage: img)
          .resizable()
          .scaledToFill()
          .frame(width: 115, height: 115)
          .clipShape(Circle())
          .overlay(
            Circle().stroke(
              Color(red: 254 / 255, green: 13 / 255, blue: 231 / 255),
              lineWidth: 1
            )
          )
          .overlay(
            Image(systemName: "camera.fill")
              .resizable()
              .scaledToFit()
              .frame(width: 24, height: 24)
              .foregroundColor(.white)
              .frame(width: 34, height: 34)
              .background(
                Color(
                  red: 254 / 255,
                  green: 13 / 255,
                  blue: 231 / 255
                )
              )
              .clipShape(Circle()), alignment: .bottomTrailing
          )
          .onTapGesture {
            showPicker = true
          }
          .frame(maxWidth: .infinity, alignment: .center)
      } else {
        appState.currentUser!.photoImage
          .resizable()
          .scaledToFill()
          .frame(width: 115, height: 115)
          .clipShape(Circle())
          .overlay(
            Circle().stroke(
              Color(red: 254 / 255, green: 13 / 255, blue: 231 / 255),
              lineWidth: 1
            )
          )
          .overlay(
            Image(systemName: "camera.fill")
              .resizable()
              .scaledToFit()
              .frame(width: 24, height: 24)
              .foregroundColor(.white)
              .frame(width: 34, height: 34)
              .background(
                Color(
                  red: 254 / 255,
                  green: 13 / 255,
                  blue: 231 / 255
                )
              )
              .clipShape(Circle()), alignment: .bottomTrailing
          )
          .onTapGesture {
            showPicker = true
          }
          .frame(maxWidth: .infinity, alignment: .center)
      }
      Spacer().frame(height: 16)
      Text("Upload profile photo")
        .foregroundColor(.white.opacity(0.5))
        .font(.system(size: 11, weight: .medium))
      Spacer().frame(height: 32)
      Text("Name")
        .foregroundColor(.white)
        .font(.system(size: 15, weight: .bold))
        .frame(maxWidth: .infinity, alignment: .leading)
      Spacer().frame(height: 20)
      TextField(
        "", text: $name,
        prompt: Text("Input your nick name")
          .foregroundColor(.gray)
          .font(.system(size: 14, weight: .regular)),
      )
      .autocapitalization(.none)
      .disableAutocorrection(true)
      .font(.system(size: 14, weight: .regular))
      .foregroundColor(.white)
      .padding(.horizontal, 16)
      .padding(.vertical, 18)
      .background(RoundedRectangle(cornerRadius: 20).fill(.white.opacity(0.1)))
      .submitLabel(.done)
      .onAppear {
        name = appState.currentUser?.name ?? ""
      }
      Spacer()
      Button(action: {
        Task {
          guard !isLoading else {
            return
          }

          guard !name.isEmpty else {
            return
          }
          isLoading = true
          defer { isLoading = false }
          try? await Task.sleep(nanoseconds: 500_000_000)
          if let img = selectedImage {
            if let url = saveImageToDocuments(image: img, prefix: "photo") {
              appState.currentUser?.photo = url.path
            }
          }
          appState.currentUser?.name = name
          router.path.removeLast()
        }
      }) {
        if isLoading {
          ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: .white))
            .frame(maxWidth: .infinity)
        } else {
          Text("Confirm")
            .foregroundColor(.white)
            .bold()
            .frame(maxWidth: .infinity)
        }
      }
      .buttonStyle(
        GradientButtonStyle()
      )
    }
    .sheet(isPresented: $showPicker) {
      ImagePicker(image: $selectedImage).ignoresSafeArea()
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
      ToolbarItem(placement: .principal) {
        Text("Edit")
          .foregroundColor(.white)
          .font(.system(size: 20, weight: .bold))
      }
    }

  }
}

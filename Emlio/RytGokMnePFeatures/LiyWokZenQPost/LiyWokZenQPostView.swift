import PhotosUI
import SwiftData
import SwiftUI
import UIKit

struct PostView: View {

  @Binding var show: Bool
  @State var content: String = ""
  @FocusState private var isFocused: Bool
  @State private var isLoading = false
  @State private var showPicker = false
  @State private var selectedImage: UIImage?
  @Environment(\.modelContext) private var modelContext
  @EnvironmentObject private var appState: AppState
  var body: some View {

    GeometryReader { geo in
      VStack(spacing: 0) {
        Spacer().frame(height: 40)
        ZStack(alignment: .topLeading) {
          if content.isEmpty {
            Text("Share your jewelry moments with us! Show off your latest designs!")
              .font(.system(size: 14))
              .foregroundColor(.white.opacity(0.5))
              .padding(.horizontal, 22)
              .padding(.top, 24)
          }
          TextEditor(
            text: $content,
          )
          .scrollContentBackground(.hidden)
          .background(Color.clear)
          .lineLimit(4)
          .padding(16)
          .font(.system(size: 14, weight: .regular))
          .foregroundColor(.white)
          .keyboardType(.default)
          .autocapitalization(.none)
          .background(RoundedRectangle(cornerRadius: 20).fill(.white.opacity(0.1)))
          .frame(height: 145)
          .focused($isFocused)
        }
        Spacer().frame(height: 30)
        if let img = selectedImage {
          Image(uiImage: img)
            .resizable()
            .scaledToFill()
            .frame(width: 160, height: 200)
            .cornerRadius(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .onTapGesture {
              showPicker = true
            }
        } else {
          Image("Assets/emlio_upload_icon")
            .resizable()
            .scaledToFit()
            .frame(width: 40, height: 40)
            .padding(.horizontal, 60)
            .padding(.vertical, 80)
            .background(.white.opacity(0.1))
            .cornerRadius(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .onTapGesture {
              showPicker = true
            }
        }
        Spacer()
        Button(
          action: {
            isLoading = true

            Task {
              guard let img = selectedImage else {
                isLoading = false
                return
              }
              let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
              guard !trimmedContent.isEmpty else {
                isLoading = false
                return
              }
              try? await Task.sleep(nanoseconds: 500_000_000)
              if let url = saveImageToDocuments(image: img, prefix: "post") {
                let post = PostData(
                  user: appState.currentUser!,
                  content: content,
                  image: url.path,
                  createdAt: Date()
                )
                do {
                  modelContext.insert(post)
                  try modelContext.save()
                } catch {
                }
                show = false
              }
              isLoading = false
            }
          }
        ) {
          if !isLoading {
            Text("Publish")
              .foregroundColor(.white)
              .bold()
          } else {
            ProgressView()
              .progressViewStyle(CircularProgressViewStyle(tint: .white))
          }
        }
        .buttonStyle(GradientButtonStyle())
      }
      .padding(.horizontal, 16)
      .background(
        DefaultBackground()
      )
      .onTapGesture {
        isFocused = false
      }
      .sheet(isPresented: $showPicker) {
        ImagePicker(image: $selectedImage).ignoresSafeArea()
      }
    }
    .navigationBarBackButtonHidden(true)
    .toolbar {
      ToolbarItem(placement: .navigationBarLeading) {
        Button {
          show = false
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

  }
}

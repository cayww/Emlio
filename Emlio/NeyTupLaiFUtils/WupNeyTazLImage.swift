import PhotosUI
import SwiftUI
import UIKit

func loadImageURL(
  name: String,
  subdirectory: String
) -> URL? {
  let fileName = (name as NSString).deletingPathExtension
  let extensions = ["png", "jpg", "jpeg"]

  for ext in extensions {
    if let url = Bundle.main.url(
      forResource: fileName,
      withExtension: ext,
      subdirectory: subdirectory
    ) {
      return url
    }
  }
  return nil
}

struct ImagePicker: UIViewControllerRepresentable {
  @Binding var image: UIImage?
  var selectionLimit: Int = 1

  @Environment(\.presentationMode) private var presentationMode

  func makeUIViewController(context: Context) -> PHPickerViewController {
    var config = PHPickerConfiguration()
    config.filter = .images
    config.selectionLimit = selectionLimit

    let picker = PHPickerViewController(configuration: config)
    picker.delegate = context.coordinator
    return picker
  }

  func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  class Coordinator: NSObject, PHPickerViewControllerDelegate {
    let parent: ImagePicker
    init(_ parent: ImagePicker) { self.parent = parent }

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
      picker.dismiss(animated: true)

      guard let result = results.first else { return }

      let provider = result.itemProvider
      if provider.canLoadObject(ofClass: UIImage.self) {
        provider.loadObject(ofClass: UIImage.self) { object, error in
          DispatchQueue.main.async {
            if let uiImage = object as? UIImage {
              self.parent.image = uiImage
            }
          }
        }
      }
    }
  }
}

func saveImageToDocuments(image: UIImage, prefix: String) -> URL? {
  let timestamp = Int(Date().timeIntervalSince1970)
  let fileName = "\(prefix)_\(timestamp).jpg"
  guard let data = image.jpegData(compressionQuality: 0.8) else { return nil }
  let fileManager = FileManager.default
  do {
    let documentsURL = try fileManager.url(
      for: .documentDirectory,
      in: .userDomainMask,
      appropriateFor: nil,
      create: true
    )
    let fileURL = documentsURL.appendingPathComponent(fileName)
    try data.write(to: fileURL)
    return fileURL
  } catch {
    print("保存图片失败:", error)
    return nil
  }
}

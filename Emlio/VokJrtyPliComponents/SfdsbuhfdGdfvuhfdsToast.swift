import Combine
import SwiftUI

final class ToastManager: ObservableObject {
  static let shared = ToastManager()

  @Published var message: String = ""
  @Published var isShowingToast: Bool = false

  @Published var isLoading: Bool = false

  private var timer: AnyCancellable?

  private init() {}

  func show(_ message: String, duration: TimeInterval = 2) {
    self.message = message
    withAnimation {
      self.isShowingToast = true
    }

    timer?.cancel()
    timer = Just(())
      .delay(for: .seconds(duration), scheduler: RunLoop.main)
      .sink { [weak self] _ in
        withAnimation {
          self?.isShowingToast = false
        }
      }
  }

  func showLoading() {
    withAnimation {
      self.isLoading = true
    }
  }

  func hideLoading() {
    withAnimation {
      self.isLoading = false
    }
  }
}

struct ToastView: View {
  @ObservedObject var manager = ToastManager.shared

  var body: some View {
    ZStack {
      if manager.isShowingToast {
        Text(manager.message)
          .font(.system(size: 14))
          .foregroundColor(.white)
          .padding(.horizontal, 16)
          .padding(.vertical, 10)
          .background(
            Capsule()
              .fill(Color.black.opacity(0.8))
          )
          .transition(.opacity.combined(with: .move(edge: .top)))
          .zIndex(1000)
      }

      if manager.isLoading {
        Color.black.opacity(0.3)
          .ignoresSafeArea()
          .transition(.opacity)
          .zIndex(999)

        ProgressView()
          .progressViewStyle(CircularProgressViewStyle(tint: .white))
          .scaleEffect(1.5)
          .padding(20)
          .background(Color.black.opacity(0.7))
          .cornerRadius(12)
          .transition(.opacity)
          .zIndex(1000)
      }
    }
    .animation(.easeInOut, value: manager.isShowingToast || manager.isLoading)
  }
}

import Combine
import SwiftUI

final class ScreenProtectionManager: ObservableObject {

  static let shared = ScreenProtectionManager()

  @Published var isProtected = false

  private var cancellables = Set<AnyCancellable>()

  private init() {
    setup()
  }
  private func setup() {

    NotificationCenter.default.publisher(
      for: UIApplication.didBecomeActiveNotification
    )
    .sink { [weak self] _ in
      self?.isProtected = false
    }
    .store(in: &cancellables)

    NotificationCenter.default.publisher(
      for: UIApplication.willResignActiveNotification
    )
    .sink { [weak self] _ in
      self?.isProtected = true
    }
    .store(in: &cancellables)

    NotificationCenter.default.publisher(
      for: UIScreen.capturedDidChangeNotification
    )
    .sink { [weak self] _ in
      self?.isProtected = UIScreen.main.isCaptured
    }
    .store(in: &cancellables)
  }
}
struct ScreenBlurOverlay: View {

  @ObservedObject var protector = ScreenProtectionManager.shared

  var body: some View {
    if protector.isProtected {
      Color.black
        .ignoresSafeArea()
        .transition(.opacity)
    }
  }
}

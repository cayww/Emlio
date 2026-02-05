import Combine
import CoreLocation
import SwiftUI

struct GuxsinvdsfDialog: View {
  @Binding var isActive: Bool
  @EnvironmentObject private var locationManager: LocationManager
  func close() {
    isActive = false
  }

  var body: some View {
    ZStack {
      Color.black.opacity(0.5)
      VStack {
        Spacer().frame(height: 26)
        Text("Location permission")
          .foregroundColor(.black)
          .multilineTextAlignment(.center)
          .font(.system(size: 28, weight: .bold))
          .padding(.bottom, 17)
        Text(
          "This app needs location access for sharing, discovering events, and using location-based features. Location data is used responsibly with your consent. Privacy and security are our priorities."
        )
        .foregroundColor(.black)
        .multilineTextAlignment(.center)
        .font(.system(size: 13, weight: .medium))
        .padding(.bottom, 17)
        Button {
          if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
          }
        } label: {
          Text("Set now")
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
            ],
            startPoint: .top,
            endPoint: .bottom
          )
        )
        .clipShape(RoundedRectangle(cornerRadius: 100))
        .padding(.bottom, 25)
      }
      .fixedSize(horizontal: false, vertical: true)
      .padding(.horizontal, 20)
      .background(
        Image("Assets/emlio_pay_dialog_bg")
          .resizable()
          .scaledToFill()
      )
      .cornerRadius(30)
      .padding(.horizontal, 30)
    }
    .onReceive(locationManager.$authStatus) { authorized in
      if authorized == .authorizedAlways || authorized == .authorizedWhenInUse {
        close()
      }
    }
    .ignoresSafeArea()
  }
}

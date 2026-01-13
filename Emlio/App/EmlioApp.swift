//
//  EmlioApp.swift
//  Emlio
//
//  Created by yangyang on 2026/1/12.
//

@_exported import HotSwiftUI
import SwiftData
import SwiftUI

@main
struct EmlioApp: App {
  let container: ModelContainer

  init() {
    #if DEBUG
      Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")?.load()
      if let path = Bundle.main.path(
        forResource:
          "iOSInjection", ofType: "bundle")
      {
        Bundle(path: path)!.load()
      }
    #endif

    do {
      container = try ModelContainer(for: UserData.self)
    } catch {
      fatalError("Failed to create ModelContainer: \(error)")
    }
  }

  var body: some Scene {
    WindowGroup {
      RootView().enableInjection()
    }
    .modelContainer(container)
  }
}

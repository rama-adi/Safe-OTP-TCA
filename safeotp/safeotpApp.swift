//
//  safeotpApp.swift
//  safeotp
//
//  Created by Rama Adi Nugraha on 28/12/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct safeotpApp: App {
    @MainActor
      static let store = Store(initialState: AppFeature.State()) {
        AppFeature()
          ._printChanges()
      }
    
    var body: some Scene {
        WindowGroup {
            AppView(store: Self.store)
        }
    }
}

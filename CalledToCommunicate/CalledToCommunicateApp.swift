//
//  CalledToCommunicateApp.swift
//  CalledToCommunicate
//
//  Created by Tirzaan on 3/24/26.
//

import SwiftUI
import FirebaseKit

@main
struct CalledToCommunicateApp: App {
    @State private var appState: AppState

    init() {
        FirebaseManager.configure()
        _appState = State(initialValue: AppState())
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appState)
        }
    }
}

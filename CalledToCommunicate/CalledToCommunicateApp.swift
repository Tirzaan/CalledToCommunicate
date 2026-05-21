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
    @StateObject private var navManager = NavigationManager()

    init() {
        FirebaseManager.configure()
        _appState = State(initialValue: AppState())
    }

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $navManager.path) {
                RootView()
                    .environment(appState)
                    .environmentObject(navManager)
                    .onOpenURL { url in
                        _ = GoogleSignInService.shared.handle(url)
                    }
                    .navigationDestination(for: AppDestination.self) { destination in
                        AppDestinationView(destination)
                    }
            }
        }
    }
}

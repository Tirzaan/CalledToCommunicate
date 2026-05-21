//
//  RootView.swift
//  CalledToCommunicate
//
//  Created by Tirzaan on 3/26/26.
//

import SwiftUI
import SFSymbols
import FirebaseKit

@Observable
class Onboarding {
    var isComplete: Bool = true
}

struct RootView: View {
    @EnvironmentObject private var navManager: NavigationManager
    
    @State private var isSignedIn = AuthService.shared.isSignedIn
    @State private var onboarding = Onboarding()
    @State private var showFullScreenCover: Bool = false
    
    var body: some View {
        TabView {
            Tab("Groups", systemImage: SFSymbol.person3) {
                GroupsView()
            }
            
            Tab("Chats", systemImage: SFSymbol.bubbleLeftAndBubbleRightFill) {
                ChatsView()
            }
            
            Tab("Settings", systemImage: SFSymbol.gear) {
                SettingsView()
            }
        }
        .onAppear {
            _ = AuthService.shared.addAuthStateListener { user in
                isSignedIn = user != nil
                if isSignedIn && onboarding.isComplete {
                    showFullScreenCover = false
                } else {
                    showFullScreenCover = true
                }
            }
            showFullScreenCover = !isSignedIn
        }
        .onChange(of: onboarding.isComplete) {
            if isSignedIn && onboarding.isComplete {
                showFullScreenCover = false
            } else {
                showFullScreenCover = true
            }
        }
        .fullScreenCover(isPresented: $showFullScreenCover) {
            NavigationStack(path: $navManager.path) {
                WelcomeView()
                    .interactiveDismissDisabled()
                    .environmentObject(navManager)
                    .environment(onboarding)
                    .navigationDestination(for: AppDestination.self) { destination in
                        AppDestinationView(destination)
                            .environmentObject(navManager)
                            .environment(onboarding)
                    }
            }
        }
    }
}

#Preview {
    RootView()
}

//
//  RootView.swift
//  CalledToCommunicate
//
//  Created by Tirzaan on 3/26/26.
//

import SwiftUI
import SFSymbols
import FirebaseKit

struct RootView: View {
    @State private var isSignedIn = AuthService.shared.isSignedIn
    @State private var showSheet = false
    
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
            }
            showSheet = !isSignedIn
        }
        .onChange(of: AuthService.shared.isSignedIn) { _, isSignedIn in
            showSheet = !isSignedIn
        }
        .sheet(isPresented: $showSheet) {
            SignUpView()
                .interactiveDismissDisabled()
        }
    }
}

#Preview {
    RootView()
}

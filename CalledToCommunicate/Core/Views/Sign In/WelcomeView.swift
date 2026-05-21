//
//  WelcomeView.swift
//  CalledToCommunicate
//
//  Created by Tirzaan on 5/20/26.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject private var navManager: NavigationManager
    
    var body: some View {
        VStack {
            ImageLoaderView()
                .ignoresSafeArea()
            
            VStack {
                Text("Welcome")
                    .font(.title)
                    .fontWeight(.bold)
                Text("Called to Learn Academy!")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .frame(maxHeight: 250, alignment: .top)
            
            Text("Sign In")
                .defaultButton {
                    navManager.path.append(AppDestination.signIn)
                }
                .padding()
        }
    }
}

#Preview {
    @Previewable @State var navManager = NavigationManager()
    NavigationStack(path: $navManager.path) {
        WelcomeView()
            .environmentObject(navManager)
    }
}

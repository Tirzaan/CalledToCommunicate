//
//  ProfileView.swift
//  CalledToCommunicate
//
//  Created by Tirzaan on 4/7/26.
//

import SwiftUI
import FirebaseKit

struct ProfileView: View {
    var body: some View {
        VStack {
            List {
                Text("Name: \(AuthService.shared.displayName ?? "User")")
                Text("Email: \(AuthService.shared.userEmail ?? "user@example.com")")
                Text("UserID: \(AuthService.shared.userID ?? "1234567890ABC")")
            }
            
            Text("Sign Out")
                .defaultButton {
                    signout()
                }
                .padding(.horizontal)
            
            Text("Delete Account")
                .destructiveButton {
                    deleteAccount()
                }
                .padding(.horizontal)
        }
    }
    
    private func signout() {
        do {
            try AuthService.shared.signOut()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func deleteAccount() {
        Task {
            do {
                try await FirestoreService.shared.delete(collection: "users", documentID: AuthService.shared.userID ?? "1234567890ABC")
                try await AuthService.shared.deleteAccount()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    ProfileView()
}

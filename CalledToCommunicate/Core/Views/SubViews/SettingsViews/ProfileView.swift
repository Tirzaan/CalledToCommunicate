//
//  ProfileView.swift
//  CalledToCommunicate
//
//  Created by Tirzaan on 4/7/26.
//

import SwiftUI
import FirebaseKit

struct ProfileView: View {
    @State private var showConfirmAccountAlert: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertSubtitle: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack {
            List {
                Text("Name: \(AuthService.shared.displayName ?? "User")")
                Text("Email: \(AuthService.shared.userEmail ?? "user@example.com")")
                Text("UserID: \(AuthService.shared.userID ?? "1234567890ABC")")
            }
            
            Text("Sign Out")
                .defaultButton {
                    if AuthService.shared.isSignedIn {
                        signout()
                    } else {
                        alertTitle = "Not Signed In"
                        alertSubtitle = "you are not signed into an account"
                        showAlert = true
                    }
                }
            
            Text("Delete Account")
                .destructiveButton {
                    if AuthService.shared.isSignedIn {
                        showConfirmAccountAlert = true
                    } else {
                        alertTitle = "Not Signed In"
                        alertSubtitle = "you are not signed into an account"
                        showAlert = true
                    }
                }
                .alert(alertTitle, isPresented: $showAlert) {
                    Button("OK") {
                        alertTitle = ""
                        alertSubtitle = ""
                    }
                } message: {
                    Text(alertSubtitle)
                }
        }
        .alert("Please Confirm Account", isPresented: $showConfirmAccountAlert) {
            TextField("Email...", text: $email)
            TextField("Password...", text: $password)
            Button("Delete", role: .destructive) {
                signIn()
                deleteAccount()
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }
    
    private func signIn() {
        Task {
            do {
                _ = try await AuthService.shared.signIn(email: email, password: password)
            } catch {
                print(error.localizedDescription)
            }
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
                let userID = AuthService.shared.userID ?? ""
                try await AuthService.shared.deleteAccount()
                try await FirestoreService.shared.delete(collection: "users", documentID: userID)
            } catch {
                if error.localizedDescription == "This operation is sensitive and requires recent authentication. Log in again before retrying this request." {
                    try? AuthService.shared.signOut()
                }
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    ProfileView()
}

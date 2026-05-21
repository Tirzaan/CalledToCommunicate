//
//  EmailSignIn.swift
//  CalledToCommunicate
//
//  Created by Tirzaan on 4/8/26.
//

import SwiftUI
import ExtentionsPlus
import FirebaseKit
internal import FirebaseAuth

struct EmailSignIn: View {
    @EnvironmentObject private var navManager: NavigationManager
    @Environment(Onboarding.self) private var onboarding
    @Environment(\.dismiss) private var dismiss
    
    @State private var email = ""
    @State private var password = ""
    
    @State private var showAlert = false
    @State private var alertTitle = "Title"
    @State private var alertSubtitle = "Subtitle"
    @State private var error = ""
    
    @State private var newUser = false
    
    var body: some View {
        VStack(spacing: 8) {
            List {
                TextField("Enter Email...", text: $email)
                SecureField("Enter Password...", text: $password)
                
                if newUser {
                    SecureField("Confirm Password...", text: $password)
                }
            }
            
            Text(newUser ? "Sign Up" : "Sign In")
                .defaultButton {
                    if newUser {
                        if emailIsApproved() && passwordIsApproved() {
                            signUp()
                        }
                    } else {
                        signIn()
                    }
                }
            
            Text(newUser ? "Already have an account?" : "Don't have an account?")
                .asButton(.tap) {
                    newUser.toggle()
                }
                .foregroundStyle(.blue)
        }
        .alert(alertTitle, isPresented: $showAlert, actions: {
            Button("OK") {
                alertTitle = ""
                alertSubtitle = ""
                error = ""
            }
        }, message: {
            Text(alertSubtitle)
        })
        .navigationTitle(newUser ? "Sign Up" : "Sign In")
    }
    
    func signUp() {
        Task {
            do {
                onboarding.isComplete = false
                
                let user = try await AuthService.shared.signUp(email: email, password: password)
                
                let userModel = UserModel(id: user.uid, name: "", tribe: nil, role: nil, dateCreated: .now, birthDate: nil, email: email)
                
                try await FirestoreService.shared.save(userModel, collection: "users")
                
                navManager.path.append(AppView.personalInfo)
            } catch {
                if error.localizedDescription == "The email address is badly formatted." || error.localizedDescription == "The email address is badly formatted." || error.localizedDescription == "The email address is already in use by another account." {
                    emailError(error.localizedDescription)
                } else if error.localizedDescription == "The password must be 6 characters long or more." {
                    passwordError(error.localizedDescription)
                } else {
                    genericError(error.localizedDescription)
                }
                
                print(error.localizedDescription)
            }
        }
    }
    
    func signIn() {
        Task {
            do {
                _ = try await AuthService.shared.signIn(email: email, password: password)
                
                dismiss()
            } catch {
                genericError(error.localizedDescription)
                print(error.localizedDescription)
            }
        }
    }
    
    private func emailError(_ error: String) {
        alertTitle = "Email Invalid"
        alertSubtitle = error
        showAlert = true
    }
    
    private func passwordError(_ error: String) {
        alertTitle = "Password Invalid"
        alertSubtitle = error
        showAlert = true
    }
    
    private func genericError(_ error: String) {
        alertTitle = "Error"
        alertSubtitle = error
        showAlert = true
    }
    
    private func emailIsApproved() -> Bool {
        if email.isEmpty {
            emailError("Email is Empty, please enter an Email")
            return false
        } else {
            return true
        }
    }
    
    private func passwordIsApproved() -> Bool {
        if password.isEmpty {
            passwordError("Password is Empty, please enter an Password")
            return false
        } else {
            return true
        }
    }
}

#Preview {
    EmailSignIn()
}

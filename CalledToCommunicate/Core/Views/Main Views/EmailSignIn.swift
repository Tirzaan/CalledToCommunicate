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
    @Environment(\.dismiss) private var dismiss
    
    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @State private var selectedTribe = "None"
    @State private var selectedBirthdate = Date()
    @State private var tribes: [String] = ["None"]
    @State private var selectedRole = "Student"
    @State private var roles: [String] = ["None"]
    
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
                    TextField("Enter Name...", text: $name)
                    DatePicker("Select Birthdate", selection: $selectedBirthdate, displayedComponents: .date)
                    
                    Picker("Select a role", selection: $selectedRole) {
                        ForEach(roles, id: \.self) { role in
                            Text(role)
                        }
                    }
                    .pickerStyle(.menu)
                    if selectedRole == "Student" {
                        Picker("Select a Tribe", selection: $selectedTribe) {
                            ForEach(tribes, id: \.self) { tribe in
                                Text(tribe)
                            }
                        }
                        .pickerStyle(.menu)
                    }
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
        .task {
            await loadRoles()
        }
        .task {
            await loadTribes()
        }
    }
    
    private func loadRoles() async {
        do {
            roles = try await FirestoreService.shared.fetchField(
                collection: "admin_controls",
                documentID: "roles",
                field: "list_of_roles",
                as: [String].self
            ) ?? ["None"]
            selectedRole = roles.first ?? "None"
        } catch {
            print("Failed to load tribes: \(error.localizedDescription)")
        }
    }
    
    private func loadTribes() async {
        do {
            tribes = try await FirestoreService.shared.fetchField(
                collection: "admin_controls",
                documentID: "tribes",
                field: "list_of_tribes",
                as: [String].self
            ) ?? ["None"]
            selectedTribe = tribes.first ?? "None"
        } catch {
            print("Failed to load tribes: \(error.localizedDescription)")
        }
    }
    
    func signUp() {
        Task {
            do {
                let user = try await AuthService.shared.signUp(email: email, password: password)
                
                let userModel = UserModel(id: user.uid, name: name, tribe: selectedTribe, role: selectedRole, dateCreated: .now, birthDate: selectedBirthdate, email: email)
                
                try await FirestoreService.shared.save(userModel, collection: "users")
                
                _ = try await AuthService.shared.updateDisplayName(name)
                
                dismiss()
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

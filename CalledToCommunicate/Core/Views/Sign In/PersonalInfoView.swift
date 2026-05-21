//
//  PersonalInfoView.swift
//  CalledToCommunicate
//
//  Created by Tirzaan on 5/20/26.
//

import SwiftUI
import FirebaseKit

// _ = try await AuthService.shared.updateDisplayName(name)

struct PersonalInfoView: View {
    @EnvironmentObject private var navManager: NavigationManager
    @Environment(Onboarding.self) private var onboarding
    
    @State private var name = ""
    @State private var selectedTribe = "None"
    @State private var selectedBirthdate = Date()
    @State private var tribes: [String] = ["None"]
    @State private var selectedRole = "Student"
    @State private var roles: [String] = ["None"]
    
    var body: some View {
        List {
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
            
            Spacer()
            
            Text("Done")
                .defaultButton {
                    onboarding.isComplete = true
                }
        }
        .navigationTitle("Personal Info")
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
}

#Preview {
    PersonalInfoView()
}

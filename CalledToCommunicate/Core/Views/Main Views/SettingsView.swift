//
//  SettingsView.swift
//  CalledToCommunicate
//
//  Created by Tirzaan on 3/26/26.
//

import SwiftUI
import ExtentionsPlus
import FirebaseKit

enum SettingRoute: Hashable {
    case profile
}

struct SettingsView: View {
    @State private var path: NavigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                SettingListCell(systemImage: "person.fill", settingName: "Account") {
                    path.append(SettingRoute.profile)
                }
                    
            }
            .navigationDestination(for: SettingRoute.self) { route in
                switch route {
                case .profile:
                    ProfileView()
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}

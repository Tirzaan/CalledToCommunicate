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
    case notifications
    case audio
}

struct SettingsView: View {
    @State private var path: NavigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                SettingListCell(systemImage: "person.fill", settingName: "Account") {
                    path.append(SettingRoute.profile)
                }
                
                SettingListCell(systemImage: "bell.fill", settingName: "Notifications") {
                    path.append(SettingRoute.notifications)
                }
                
                SettingListCell(systemImage: "waveform", settingName: "Audio") {
                    path.append(SettingRoute.audio)
                }
            }
            .navigationDestination(for: SettingRoute.self) { route in
                switch route {
                case .profile:
                    ProfileView()
                case .notifications:
                    NotificationSettingsView()
                case .audio:
                    AudioSettingsView()
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}

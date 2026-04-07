//
//  GroupsView.swift
//  CalledToCommunicate
//
//  Created by Tirzaan on 3/26/26.
//

import SwiftUI
import FirebaseKit

struct GroupsView: View {
    var body: some View {
        NavigationStack {
            Text(AuthService.shared.userID ?? "no ID Found")
            Text(AuthService.shared.isSignedIn.description)
            Text("Groups")
                .navigationTitle("Groups")
        }
    }
}

#Preview {
    GroupsView()
}

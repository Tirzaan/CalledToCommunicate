//
//  GroupsView.swift
//  CalledToCommunicate
//
//  Created by Tirzaan on 3/26/26.
//

import SwiftUI
import FirebaseKit

struct GroupsView: View {
    @State private var groups: [ChatModel] = []
    
    var body: some View {
        NavigationStack {
            Text("Groups")
                .navigationTitle("Groups")
        }
        .onAppear {
            Task {
                groups = try await FirestoreService.shared.fetchAll(collection: "chats", as: ChatModel.self)
            }
        }
    }
}

#Preview {
    GroupsView()
}

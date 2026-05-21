//
//  GroupsView.swift
//  CalledToCommunicate
//
//  Created by Tirzaan on 3/26/26.
//

import SwiftUI
import ExtentionsPlus
import FirebaseKit
import FirebaseFirestore

struct GroupsView: View {
    @State private var path: NavigationPath = NavigationPath()
    
    @State private var groups: [ChatModel] = ChatModel.mocks
    @State private var showAddChat: Bool = false
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(groups) { group in
                    ChatListCell(
                        imageName: group.imageURL,
                        title: group.title,
                        lastMessage: group.lastMessage?.message,
                        lastChatTime: group.lastMessage?.dateCreated
                    ) {
                        path.append(group)
                    }
                    .asButton(.press) { }
                    .swipeActions {
                        Button {
                            deleteGroup(group: group)
                        } label: {
                            VLabel(group.ownerId == AuthService.shared.userID ? "delete" : "Leave", systemImage: group.ownerId == AuthService.shared.userID ? "trash.fill" : "rectangle.portrait.and.arrow.right")
                        }
                        .tint(.red)
                        
                        Button {
                            
                        } label: {
                            VLabel("Mute", systemImage: "bell.slash.fill")
                        }
                    }
                }
            }
            .navigationTitle("Groups")
            .navigationDestination(for: ChatModel.self) { destination in
                ChatView(chat: destination)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button("EDIT", systemImage: "pencil") {
                            
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                    }

                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: "plus")
                        .asButton {
                            addGroup()
                        }
                }
            }
            .sheet(isPresented: $showAddChat) {
                AddChatView()
            }
        }
        .task {
//            await loadGroups()
        }
        .task {
//            listenToGroups()
        }
    }
    
    private func listenToGroups() {
        _ = FirestoreService.shared.listen(collection: "chats", onChange: { (allGroups: [ChatModel]) in
            let onlyGroups = filterGroups(allGroups: allGroups)
            self.groups = onlyGroups
        })
    }
    
    private func loadGroups() async {
        do {
            let allGroups = try await FirestoreService.shared.fetchAll(collection: "chats", as: ChatModel.self)
            let onlyGroups = filterGroups(allGroups: allGroups)
            self.groups = onlyGroups
        } catch {
            print("Failed to fetch groups: \(error)")
        }
    }
    
    private func filterGroups(allGroups: [ChatModel]) -> [ChatModel] {
        let myID = AuthService.shared.userID ?? ""
        let onlyMyGroups = allGroups.filter { $0.users.contains(myID) }
        let onlyGroups = onlyMyGroups.filter { $0.users.count > 2 }
        return onlyGroups
    }
    
    private func addGroup() {
        showAddChat = true
    }
    
    private func deleteGroup(group: ChatModel) {
        Task {
            guard let currentUserID = AuthService.shared.userID else { return }
            var updatedUsers = group.users
            if let idx = updatedUsers.firstIndex(of: currentUserID) {
                updatedUsers.remove(at: idx)
            }

            do {
                if group.ownerId == currentUserID {
                    try await FirestoreService.shared.delete(collection: "chats", documentID: group.id)
                } else {
                    try await FirestoreService.shared.updateFields(
                        collection: "chats",
                        documentID: group.id,
                        fields: ["users": updatedUsers]
                    )
                }
            } catch {
                print("Failed to update/delete group: \(error)")
            }
        }
    }
}

#Preview {
    GroupsView()
}

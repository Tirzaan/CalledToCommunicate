//
//  ChatsView.swift
//  CalledToCommunicate
//
//  Created by Tirzaan on 3/26/26.
//

import SwiftUI
import FirebaseKit
import ExtentionsPlus

struct ChatsView: View {
    @State private var path: NavigationPath = NavigationPath()
    
    @State private var chats: [ChatModel] = []
    @State private var showAddChat: Bool = false
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(chats) { group in
                    ChatListCell(
                        imageName: group.imageURL,
                        title: group.title,
                        lastMessage: group.lastMessage?.message,
                        lastChatTime: group.lastMessage?.dateCreated
                    ) {
                        path.append(group)
                    }
                    .asButton(.press) { }
                }
            }
            .navigationTitle("Chats")
            .navigationDestination(for: ChatModel.self) { destination in
                ChatView(chat: destination)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: "plus")
                        .asButton {
                            addChat()
                        }
                }
            }
            .sheet(isPresented: $showAddChat) {
                AddChatView()
            }
        }
        .task {
            await loadChats()
        }
        .task {
            listenToChats()
        }
    }
    
    private func listenToChats() {
        _ = FirestoreService.shared.listen(collection: "chats", onChange: { (allChats: [ChatModel]) in
            let onlyChats = filterChats(allChats: allChats)
            self.chats = onlyChats
        })
    }
    
    private func loadChats() async {
        do {
            let allChats = try await FirestoreService.shared.fetchAll(collection: "chats", as: ChatModel.self)
            let onlyChats = filterChats(allChats: allChats)
            self.chats = onlyChats
        } catch {
            print("Failed to fetch groups: \(error)")
        }
    }
    
    private func filterChats(allChats: [ChatModel]) -> [ChatModel] {
        let myID = AuthService.shared.userID ?? ""
        let onlyMyChats = allChats.filter { $0.users.contains(myID) }
        let onlyChats = onlyMyChats.filter { $0.users.count < 3 }
        return onlyChats
    }
    
    private func addChat() {
        showAddChat = true
    }
}

#Preview {
    ChatsView()
}

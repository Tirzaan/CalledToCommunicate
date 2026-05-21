//
//  ChatView.swift
//  CalledToCommunicate
//
//  Created by Tirzaan on 4/15/26.
//

import SwiftUI
import ExtentionsPlus
import FirebaseFirestore
import FirebaseKit

struct ChatView: View {
    var chat: ChatModel
    
    @State private var listener: ListenerRegistration?
    @State private var messages: [ChatMessageModel] = []
    @State private var newMessage = ""
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    ForEach(messages) { message in
                        MessageBubble(message: message, currentUserId: AuthService.shared.userID ?? "")
                            .id(message.id)
                    }
                    .onAppear {
                        Task {
                            try? await Task.sleep(for: .milliseconds(20))
                            if let last = messages.last {
                                proxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                }
            }
            
            HStack {
                TextField("message...", text: $newMessage)
                
                Circle()
                    .fill(.blue)
                    .overlay {
                        Image(systemName: "arrow.up")
                    }
                    .frame(width: 50)
                    .asButton(.press) {
                        sendMessage()
                    }
            }
            .padding()
        }
        .onAppear { startListening() }
        .onDisappear { listener?.remove() }
    }
    
    private func startListening() {
            listener = FirestoreService.shared.listenToSubcollection(
                collection: "chats",
                documentID: chat.id,
                subcollection: "messages",
                orderBy: "date_created",
                descending: false,
                limit: 50,
                as: ChatMessageModel.self
            ) { messages in
                self.messages = messages
            }
        }
        
        private func sendMessage() {
            guard !newMessage.isEmpty else { return }
            let message = ChatMessageModel(
                id: UUID().uuidString,
                author: AuthService.shared.userID ?? "",
                chatId: chat.id,
                dateCreated: .now,
                message: newMessage,
                readBy: [AuthService.shared.userID ?? ""]
            )
            Task {
                try? await FirestoreService.shared.saveToSubcollection(
                    message,
                    collection: "chats",
                    documentID: chat.id,
                    subcollection: "messages"
                )
            }
            newMessage = ""
        }
}

#Preview {
    NavigationStack {
        ChatView(chat: ChatModel(
            id: "mock_chat_1",
            title: "The Fun Ones",
            dateCreated: Date.on(year: 2013, month: 5, day: 15, hour: 9, minute: 30, second: 0),
            ownerId: "mock_user_1",
            imageURL: "https://picsum.photos/id/1015/600/600",
            users: ["mock_user_1", "mock_user_3", "mock_user_4"],
            lastMessage: LastMessageModel(
                message: "Who's up for brunch at 10:00AM today at Mcdonalds? or would you guys like a different place?",
                author: "mock_user_1",
                dateCreated: Date.on(year: 2013, month: 5, day: 16, hour: 10, minute: 0, second: 0),
                readBy: ["mock_user_1"]
            )
        ))
    }
}

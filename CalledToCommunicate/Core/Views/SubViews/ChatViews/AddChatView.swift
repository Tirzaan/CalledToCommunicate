//
//  AddChatView.swift
//  CalledToCommunicate
//
//  Created by Tirzaan on 4/17/26.
//

import SwiftUI
import FirebaseKit
import PhotosUI
import SFSymbols

struct AddChatView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var newChat: ChatModel = .mocks.first!
    @State private var title: String = ""
    @State private var users: [UserModel] = []
    @State private var selectedUsers: Set<UserModel> = []
    @State private var selectedItem: PhotosPickerItem?
    @State private var imageData: Data?
    @State private var selectedImage: Image? = Image("DefaultChatIcon")
    @State private var showCamera = false
    @State private var showPhotoPicker = false
    @State private var showFilePicker = false
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    TextField("Title...", text: $title)
                    pickUsers
                    chooseImage
                    image
                }
                .onChange(of: selectedItem) { _, newItem in
                    imageToData(newItem: newItem)
                }
                .sheet(isPresented: $showCamera) {
                    CameraPicker(image: $selectedImage)
                }
                .photosPicker(
                    isPresented: $showPhotoPicker,
                    selection: $selectedItem,
                    matching: .images
                )
                .fileImporter(
                    isPresented: $showFilePicker,
                    allowedContentTypes: [.image],
                    allowsMultipleSelection: false
                ) { result in
                    handleFileImport(result: result)
                }
                
                Text("Create Chat")
                    .defaultButton {
                        createChat()
                    }
            }
            .task {
                await loadUsers()
            }
            .onAppear  {
                AnalyticsService.shared.logEvent("Loaded AddChatsView")
            }
        }
    }
    
    private var pickUsers: some View {
        NavigationLink {
            List {
                MultiPicker(
                    items: users,
                    itemLabel: { $0.name ?? "User" },
                    selection: $selectedUsers
                )
            }
        } label: {
            let usersList = selectedUsers.map { $0.name ?? "User" }.joined(separator: ", ")
            Text("PICK USERS [\(usersList)]")
                .lineLimit(1)
        }
    }
    
    private var chooseImage: some View {
        Menu {
            Button("Take Picture", systemImage: SFSymbol.camera) {
                showCamera = true
            }
            
            Button("Photo Library", systemImage: "photo") {
                showPhotoPicker = true
            }
            
            Button("Files", systemImage: SFSymbol.folder) {
                showFilePicker = true
            }
        } label: {
            Text("Choose Chat Icon")
        }
    }
    
    @ViewBuilder
    private var image: some View {
        if let image = selectedImage {
            image
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
        } else {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 300, height: 300)
                .overlay(Text("No Image Selected"))
        }
    }
    
    private func handleFileImport(result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            if let url = urls.first {
                guard url.startAccessingSecurityScopedResource() else { return }
                defer { url.stopAccessingSecurityScopedResource() }
                
                if let uiImage = UIImage(contentsOfFile: url.path) {
                    selectedImage = Image(uiImage: uiImage)
                    imageData = uiImage.jpegData(compressionQuality: 0.8)
                }
            }
        case .failure(let error):
            print("File import error: \(error)")
        }
    }
    
    private func imageToData(newItem: PhotosPickerItem?) {
        Task {
            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                imageData = data
                if let uiImage = UIImage(data: data) {
                    selectedImage = Image(uiImage: uiImage)
                }
            }
        }
    }
    
    private func loadUsers() async {
        do {
            var allUsers = try await FirestoreService.shared.fetchAll(
                collection: "users",
                as: UserModel.self
            )
            let myID = AuthService.shared.userID ?? ""
            allUsers.removeAll(where: { $0.id ==  myID })
            
            users = allUsers
        } catch {
            print("Failed to load users: \(error)")
        }
    }
    
    private func createChat() {
        Task {
            do {
                guard !title.isEmpty else {
                    print("No title")
                    return
                }
                guard selectedUsers.count > 0 else {
                    print("No users")
                    return
                }
                
                var imageURL = "https://firebasestorage.googleapis.com/v0/b/called-to-communicate.firebasestorage.app/o/Images%2FChat_Images%2FDefault%20Chat%20Icon.png?alt=media&token=bfd881d2-50f2-4515-971e-94f9391f6b33"
                let chatId = UUID().uuidString
                
                if let data = imageData {
                    let uploadedImage = try await StorageService().upload(
                        data: data,
                        path: "Images/Chat_Images/\(chatId)/Chat_Icon"
                    )
                    imageURL = uploadedImage.absoluteString
                    
                } else {
                    print("No image data available")
                }
                
                var selectedUserIds = selectedUsers.map { $0.id }
                if let userId = AuthService.shared.userID {
                    selectedUserIds.append(userId)
                }
                
                let newChat = ChatModel(
                    id: chatId,
                    title: title,
                    dateCreated: .now,
                    ownerId: AuthService.shared.userID,
                    imageURL: imageURL,
                    users: selectedUserIds,
                    lastMessage: nil
                )
                
                try await FirestoreService.shared.save(newChat, collection: "chats")
                dismiss()
            } catch {
                print("Error creating chat: \(error)")
            }
        }
    }
    
    private func add() {
        Task {
            do {
                try await FirestoreService.shared.save(newChat, collection: "chats")
            } catch {
                print("Error saving new chat: \(error)")
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddChatView()
    }
}

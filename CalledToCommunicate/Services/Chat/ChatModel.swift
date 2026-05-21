//
//  ChatModel.swift
//  CalledToCommunicate
//
//  Created by Tirzaan on 4/7/26.
//

import Foundation
import ExtentionsPlus

struct LastMessageModel: Codable, Hashable {
    let message: String
    let author: String?
    let dateCreated: Date?
    let readBy: [String]
    
    enum CodingKeys: String, CodingKey {
        case message
        case author
        case dateCreated = "date_created"
        case readBy = "read_by"
    }
}

struct ChatModel: Identifiable, Codable, Hashable {
    let id: String
    let title: String?
    let dateCreated: Date?
    let ownerId: String?
    let imageURL: String?
    let users: [String]
    let lastMessage: LastMessageModel?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case dateCreated = "date_created"
        case ownerId = "owner_id"
        case imageURL = "image_url"
        case users
        case lastMessage = "last_message"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ChatModel, rhs: ChatModel) -> Bool {
        lhs.id == rhs.id
    }
    
    static var mocks: [ChatModel] = [
        ChatModel(
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
        ),
        ChatModel(
            id: "mock_chat_2",
            title: "Design Standup",
            dateCreated: Date.on(year: 2023, month: 11, day: 20, hour: 10, minute: 0, second: 0),
            ownerId: "mock_user_2",
            imageURL: "https://picsum.photos/id/1027/600/600",
            users: ["mock_user_2", "mock_user_5", "mock_user_6", "mock_user_7"],
            lastMessage: LastMessageModel(
                message: "Reviewing now.",
                author: "mock_user_7",
                dateCreated: Date.on(year: 2023, month: 11, day: 20, hour: 9, minute: 45, second: 0),
                readBy: ["mock_user_7"]
            )
        ),
        ChatModel(
            id: "mock_chat_3",
            title: nil,
            dateCreated: Date.on(year: 2026, month: 3, day: 30, hour: 14, minute: 45, second: 0),
            ownerId: "mock_user_3",
            imageURL: nil,
            users: ["mock_user_1", "mock_user_3"],
            lastMessage: LastMessageModel(
                message: "Did you see the game last night?",
                author: "mock_user_1",
                dateCreated: Date.on(year: 2026, month: 4, day: 1, hour: 19, minute: 0, second: 0),
                readBy: ["mock_user_1"]
            )
        ),
        ChatModel(
            id: "mock_chat_4",
            title: "Family",
            dateCreated: Date.on(year: 2025, month: 12, day: 1, hour: 18, minute: 0, second: 0),
            ownerId: "mock_user_8",
            imageURL: "https://picsum.photos/id/1005/600/600",
            users: ["mock_user_8", "mock_user_9", "mock_user_10"],
            lastMessage: LastMessageModel(
                message: "Dinner at 7?",
                author: "mock_user_9",
                dateCreated: nil,
                readBy: ["mock_user_9", "mock_user_10"]
            )
        ),
        ChatModel(
            id: "mock_chat_5",
            title: "iOS Guild",
            dateCreated: Date.on(year: 2025, month: 4, day: 15, hour: 8, minute: 0, second: 0),
            ownerId: "mock_user_11",
            imageURL: "https://picsum.photos/id/1043/600/600",
            users: ["mock_user_1", "mock_user_11", "mock_user_12", "mock_user_13"],
            lastMessage: LastMessageModel(
                message: "Nice! Ship it.",
                author: "mock_user_13",
                dateCreated: Date.on(year: 2025, month: 4, day: 15, hour: 11, minute: 30, second: 0),
                readBy: ["mock_user_13"]
            )
        )
    ]
}


//
//  ChatMessageModel.swift
//  CalledToCommunicate
//
//  Created by Tirzaan on 4/7/26.
//

import Foundation

struct ChatMessageModel: Identifiable, Codable, Hashable {
    let id: String
    let author: String?
    let chatId: String?
    let dateCreated: Date?
    let message: String
    let readBy: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case author
        case chatId = "chat_id"
        case dateCreated = "date_created"
        case message
        case readBy = "read_by"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: ChatMessageModel, rhs: ChatMessageModel) -> Bool {
        lhs.id == rhs.id
    }
}

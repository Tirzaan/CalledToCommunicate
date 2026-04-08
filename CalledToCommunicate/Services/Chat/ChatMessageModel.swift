//
//  ChatMessageModel.swift
//  CalledToCommunicate
//
//  Created by Tirzaan on 4/7/26.
//

import Foundation

struct ChatMessageModel: Identifiable, Codable {
    let id: String
    let author: String?
    let chatId: String?
    let dateCreated: Date?
    let message: String
    let readBy: [String]
}

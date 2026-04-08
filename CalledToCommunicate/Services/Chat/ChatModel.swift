//
//  ChatModel.swift
//  CalledToCommunicate
//
//  Created by Tirzaan on 4/7/26.
//

import Foundation

struct ChatModel: Identifiable, Codable {
    let id: String
    let title: String?
    let isPersonal: Bool
    let dateCreated: Date?
    let ownerId: String
    let users: [String]
}

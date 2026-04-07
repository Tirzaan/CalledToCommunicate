//
//  UserModel.swift
//  CalledToCommunicate
//
//  Created by Tirzaan on 4/6/26.
//

import Foundation
import SwiftUI

struct UserModel: Identifiable, Codable {
    let id: String
    let name: String?
    let tribe: String?
    let role: String?
    let dateCreated: Date?
    let birthDate: Date?
    let email: String?
    let isAnonymousUser: Bool?
    
    init(id: String, name: String? = nil, tribe: String? = nil, role: String? = nil, dateCreated: Date? = nil, birthDate: Date? = nil, email: String? = nil, isAnonymousUser: Bool? = nil) {
        self.id = id
        self.name = name
        self.tribe = tribe
        self.role = role
        self.dateCreated = dateCreated
        self.birthDate = birthDate
        self.email = email
        self.isAnonymousUser = isAnonymousUser
    }
}
    

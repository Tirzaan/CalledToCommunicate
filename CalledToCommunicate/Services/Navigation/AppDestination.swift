//
//  AppDestination.swift
//  CalledToCommunicate
//
//  Created by Tirzaan on 5/20/26.
//

import Foundation

enum AppDestination: Hashable, Identifiable {
    case welcome
    case signIn
    case emailSignIn
    case personalInfo
    
    var id: Self { self }
}

typealias AppView = AppDestination

//
//  AppState.swift
//  CalledToCommunicate
//
//  Created by Tirzaan on 4/6/26.
//

import SwiftUI
import FirebaseKit

@Observable
class AppState {
    private(set) var isSignedIn: Bool
    
    init() {
        self.isSignedIn = AuthService.shared.isSignedIn
    }
    
    func updateViewState(isSignedIn: Bool) {
        self.isSignedIn = isSignedIn
    }
}

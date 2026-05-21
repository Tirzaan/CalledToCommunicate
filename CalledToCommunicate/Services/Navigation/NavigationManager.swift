//
//  NavigationManager.swift
//  CalledToCommunicate
//
//  Created by Tirzaan on 5/20/26.
//

import SwiftUI
import Combine

class NavigationManager: ObservableObject {
    @Published var path: NavigationPath = NavigationPath()
}

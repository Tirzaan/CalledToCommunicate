//
//  AppDestinationView.swift
//  CalledToCommunicate
//
//  Created by Tirzaan on 5/20/26.
//

import SwiftUI

struct AppDestinationView: View {
    let destination: AppDestination
    
    init(_ destination: AppDestination) {
        self.destination = destination
    }
    
    var body: some View {
        switch destination {
        case .welcome:
            WelcomeView()
        case .signIn:
            SignInView()
        case .emailSignIn:
            EmailSignIn()
        case .personalInfo:
            PersonalInfoView()
        }
    }
}

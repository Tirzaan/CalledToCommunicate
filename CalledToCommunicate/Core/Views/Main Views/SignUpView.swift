//
//  SignUpView.swift
//  CalledToCommunicate
//
//  Created by Tirzaan on 4/6/26.
//

import SwiftUI
import FirebaseKit
import ExtentionsPlus
import SFSymbols

struct SignUpView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var path: NavigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                HStack(alignment: .center) {
                    Image(systemName: SFSymbol.envelopeFill)
                    Text("Continue with E-mail")
                }
                .LoginButton {
                    path.append("Email")
                }
                
                HStack(alignment: .center) {
                    Image(systemName: SFSymbol.appleLogo)
                    Text("Continue with Apple")
                }
                .LoginButton {
                    
                }
                
                HStack(alignment: .center) {
                    Image(systemName: SFSymbol.gCircle)
                    Text("Continue with Google")
                }
                .LoginButton {
                    
                }
                
                Spacer()
            }
            .navigationTitle("Login")
            .navigationDestination(for: String.self) { route in
                if route == "Email" {
                    EmailSignIn()
                }
            }
        }
    }
    
    
}

#Preview {
    SignUpView()
}

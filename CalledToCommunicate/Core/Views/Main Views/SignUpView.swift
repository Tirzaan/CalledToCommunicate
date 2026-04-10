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
internal import FirebaseAuth

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
                
                AppleSignInButton {  user in
                    print("Signed in as \(user.uid)")
                } onFailure: { error in
                    print(error.localizedDescription)
                }
                .padding(.horizontal)
                
                GoogleSignInButton(
                    onSuccess: { user in
                        print("Signed in as: \(user.displayName ?? "Unknown")")
                    },
                    onFailure: { error in
                        print("Error: \(error.localizedDescription)")
                    }
                )
                .padding(.horizontal)
                .overlay {
                    ZStack {
                        Rectangle()
                            .rounded(8)
                            .padding(.horizontal)
                        
                        Text("Sign In With Google")
                            .font(.headline)
                            .foregroundStyle(.white)
                        
                        Image("GoogleIcon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(16)
                            .padding(.leading, 75)
                    }
                    .allowsHitTesting(false)
                }
                
                Divider()
                
//                HStack(alignment: .center) {
//                    Image(systemName: SFSymbol.appleLogo)
//                    Text("Continue with Apple")
//                }
//                .LoginButton {
//                    
//                }
//                
//                HStack(alignment: .center) {
//                    Image(systemName: SFSymbol.gCircle)
//                    Text("Continue with Google")
//                }
//                .LoginButton {
//                    
//                }
                
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

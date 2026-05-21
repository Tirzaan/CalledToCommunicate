//
//  SignInView.swift
//  CalledToCommunicate
//
//  Created by Tirzaan on 5/20/26.
//

import SwiftUI
import FirebaseKit
import ExtentionsPlus
import SFSymbols
internal import FirebaseAuth

struct SignInView: View {
    @EnvironmentObject private var navManager: NavigationManager
    @Environment(Onboarding.self) private var onboarding
    @Environment(\.dismiss) private var dismiss
    
    @State private var sheetDestination: AppView?
    
    var body: some View {
        VStack() {
            emailSignInButtonSection
            appleSignInButtonSection
            googleSignInButtonSection
        }
        .sheet(item: $sheetDestination, content: { destination in
            switch destination {
            case .emailSignIn:
                EmailSignIn()
            case .personalInfo:
                PersonalInfoView()
            default:
                EmptyView()
            }
        })
        .navigationTitle("Login")
    }
    
    private var emailSignInButtonSection: some View {
        HStack(alignment: .center) {
            Image(systemName: SFSymbol.envelopeFill)
            Text("Continue with E-Mail")
        }
        .LoginButton {
            sheetDestination = .emailSignIn
        }
    }
    
    private var appleSignInButtonSection: some View {
        AppleSignInButton { user in
            print("Signed in as: \(user.displayName ?? "Unknown")")
            
            onboarding.isComplete = false
            navManager.path.append(AppView.personalInfo)
        } onFailure: { error in
            print("Error: \(error.localizedDescription)")
            AlertManager.showAlert(title: "ERROR", message: error.localizedDescription)
        }
        .padding(.horizontal)
    }
    
    private var googleSignInButtonSection: some View {
        GoogleSignInButton(
            onSuccess: { user in
                print("Signed in as: \(user.displayName ?? "Unknown")")
                
                onboarding.isComplete = false
                navManager.path.append(AppView.personalInfo)
            },
            onFailure: { error in
                print("Error: \(error.localizedDescription)")
                AlertManager.showAlert(title: "ERROR", message: error.localizedDescription)
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
    }
}



#Preview {
    SignInView()
}













class AlertManager {
    /// Show a basic alert with a single "OK" button
    static func showAlert(
        title: String?,
        message: String?,
        buttonTitle: String = "OK",
        completion: (() -> Void)? = nil
    ) {
        guard let vc = AlertManager.topViewController() else { return }
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: buttonTitle, style: .default) { _ in
            completion?()
        }
        
        alert.addAction(action)
        
        DispatchQueue.main.async {
            vc.present(alert, animated: true)
        }
    }
    
    /// Show an alert with a confirm + cancel button
    static func showConfirmAlert(
        title: String?,
        message: String?,
        confirmTitle: String = "Confirm",
        cancelTitle: String = "Cancel",
        isDestructive: Bool = false,
        onConfirm: (() -> Void)? = nil,
        onCancel: (() -> Void)? = nil
    ) {
        guard let vc = AlertManager.topViewController() else { return }
        
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        let confirmAction = UIAlertAction(title: confirmTitle, style: .default) { _ in
            onConfirm?()
        }
        let destructiveConfirmAction = UIAlertAction(title: confirmTitle, style: .destructive) { _ in
            onConfirm?()
        }
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
            onCancel?()
        }
        
        if isDestructive {
            alert.addAction(destructiveConfirmAction)
        } else {
            alert.addAction(confirmAction)
        }
        alert.addAction(cancelAction)
        
        DispatchQueue.main.async {
            vc.present(alert, animated: true)
        }
    }
    
    private static func topViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
            let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return nil
        }
        
        var top = window.rootViewController
        while let presented = top?.presentedViewController {
            top = presented
        }
        return top
    }
}


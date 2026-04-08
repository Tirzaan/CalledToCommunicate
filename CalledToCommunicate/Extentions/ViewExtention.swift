//
//  ViewExtention.swift
//  CalledToCommunicate
//
//  Created by Tirzaan on 4/6/26.
//

import SwiftUI
import ExtentionsPlus

extension View {
    func defaultButton(action: @escaping () -> ()) -> some View {
        self
            .foregroundStyle(.white)
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .background(.accent)
            .rounded(8)
            .padding(.horizontal)
            .asButton(.press) {
                action()
            }
    }
    
    func destructiveButton(action: @escaping () -> ()) -> some View {
        self
            .foregroundStyle(.white)
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .background(.red)
            .rounded(8)
            .padding(.horizontal)
            .asButton(.press) {
                action()
            }
    }
    
    func LoginButton(action: @escaping () -> ()) -> some View {
        self
            .foregroundStyle(.white)
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .background(.black)
            .rounded(8)
            .padding(.horizontal)
            .asButton(.press) {
                action()
            }
    }
}

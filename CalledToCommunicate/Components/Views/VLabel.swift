//
//  VLabel.swift
//  CalledToCommunicate
//
//  Created by Tirzaan on 4/28/26.
//

import SwiftUI

struct VLabel: View {
    var systemImage: String
    var text: String
    
    init(_ text: String, systemImage: String) {
        self.systemImage = systemImage
        self.text = text
    }
    
    var body: some View {
        VStack {
            Image(systemName: systemImage)
            Text(text)
        }
    }
}

#Preview {
    VLabel("Title", systemImage: "heart.fill")
}

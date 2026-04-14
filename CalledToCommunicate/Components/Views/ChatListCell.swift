//
//  ChatListCell.swift
//  CalledToCommunicate
//
//  Created by Tirzaan on 3/26/26.
//

import SwiftUI

struct ChatListCell: View {
    var imageName: String = Constants.image
    var title: String = MockData.shared.title("Chat")
    var lastMessage: String = "This is the last message"
    
    var body: some View {
        HStack {
            ImageLoaderView(imageName)
            
            VStack {
                Text(title)
                    .font(.headline)
                
                Text(lastMessage)
                    .font(.subheadline)
            }
        }
    }
}

#Preview {
    List {
        ChatListCell()
    }
}

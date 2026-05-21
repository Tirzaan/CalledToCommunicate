//
//  ChatListCell.swift
//  CalledToCommunicate
//
//  Created by Tirzaan on 3/26/26.
//

import SwiftUI
import SFSymbols
import ExtentionsPlus

struct ChatListCell: View {
    var imageName: String? = Constants.image
    var title: String? = MockData.shared.title("a Chat")
    var lastMessage: String? = "This was a really long message that should go under the time now"
    var lastChatTime: Date? = .now
    var action: (() -> ())? = { }
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Group {
                if let imageName {
                    ImageLoaderView(imageName)
                } else {
                    ZStack {
                        Rectangle()
                            .fill(Color(uiColor: .lightGray))
                        Image(systemName: SFSymbol.person3)
                            .foregroundStyle(.black)
                    }
                }
            }
            .frame(width: 60, height: 60)
            .rounded(15)
            
            // Main Content
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(title ?? "Chat")
                        .font(.headline)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    if let lastChatTime = lastChatTime {
                        Text(lastChatTime.isToday ?
                             lastChatTime.formatted(.timeOnly) :
                             lastChatTime.dayLabel)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Text(lastMessage ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
        }
        .onTapGesture {
            action?()
        }
    }
}

#Preview {
    List {
        ChatListCell()
        ChatListCell(title: "Davanni and da Boys", lastMessage: "😂OK🫡", lastChatTime: .on(year: 2015, month: 4, day: 12, hour: 6, minute: 56, second: 3) ?? .now)
        ChatListCell(title: "Realy long Title for this chat", lastMessage: "This was a realy long message that someone sent", lastChatTime: .yesterday)
    }
}

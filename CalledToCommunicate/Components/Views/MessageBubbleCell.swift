import SwiftUI
import SwiftUI

struct BubbleShape: Shape {
    var isMe: Bool

    func path(in rect: CGRect) -> Path {
        let r: CGFloat  = 16   // corner radius
        let tailH: CGFloat = 14  // how far the tail drops below the bubble body
        let tailW: CGFloat = 20  // how wide the tail base is

        // The rounded body sits in the top portion; tail hangs below
        let bodyMaxY = rect.maxY - tailH

        var p = Path()

        // Top-left → clockwise around the body
        p.move(to:    .init(x: rect.minX + r, y: rect.minY))
        p.addLine(to: .init(x: rect.maxX - r, y: rect.minY))
        p.addArc(center: .init(x: rect.maxX - r, y: rect.minY + r),
                 radius: r, startAngle: .degrees(-90), endAngle: .degrees(0), clockwise: false)
        p.addLine(to: .init(x: rect.maxX, y: bodyMaxY - r))
        p.addArc(center: .init(x: rect.maxX - r, y: bodyMaxY - r),
                 radius: r, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)

        if isMe {
            // Bottom edge with tail on the right
            p.addLine(to: .init(x: rect.maxX - tailW, y: bodyMaxY))
            p.addLine(to: .init(x: rect.maxX,         y: rect.maxY))  // tail tip
            p.addLine(to: .init(x: rect.maxX - tailW - 4, y: bodyMaxY))
            p.addLine(to: .init(x: rect.minX + r,     y: bodyMaxY))
        } else {
            // Bottom edge with tail on the left
            p.addLine(to: .init(x: rect.minX + tailW + 4, y: bodyMaxY))
            p.addLine(to: .init(x: rect.minX,             y: rect.maxY))  // tail tip
            p.addLine(to: .init(x: rect.minX + tailW,     y: bodyMaxY))
            p.addLine(to: .init(x: rect.minX + r,         y: bodyMaxY))
        }

        p.addArc(center: .init(x: rect.minX + r, y: bodyMaxY - r),
                 radius: r, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)
        p.addLine(to: .init(x: rect.minX, y: rect.minY + r))
        p.addArc(center: .init(x: rect.minX + r, y: rect.minY + r),
                 radius: r, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)

        p.closeSubpath()
        return p
    }
}

// MARK: - MessageBubble

struct MessageBubble: View {
    let message: ChatMessageModel
    let currentUserId: String

    private var isMe: Bool { message.author == currentUserId }

    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            if isMe { Spacer(minLength: 60) }

            VStack(alignment: isMe ? .trailing : .leading, spacing: 4) {
                if !isMe, let author = message.author {
                    Text(author)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 6)
                }

                Text(message.message)
                    .font(.system(size: 16))
                    .foregroundColor(isMe ? .white : .primary)
                    .padding(.horizontal, 14)
                    .padding(.top, 10)
                    .padding(.bottom, 18) // room for the tail below the text
                    .background(
                        BubbleShape(isMe: isMe)
                            .fill(isMe ? Color.blue : Color(.systemGray5))
                    )

                HStack(spacing: 4) {
                    if let date = message.dateCreated {
                        Text(date, style: .time)
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                    }
                    if isMe {
                        let readByOthers = message.readBy.filter { $0 != currentUserId }
                        Image(systemName: readByOthers.isEmpty ? "checkmark" : "checkmark.circle.fill")
                            .font(.system(size: 11))
                            .foregroundColor(readByOthers.isEmpty ? .secondary : .blue)
                    }
                }
                .padding(.horizontal, 6)
            }

            if !isMe { Spacer(minLength: 60) }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 2)
    }
}

// MARK: - Preview

#Preview {
    let me = "user_me"
    let chatId = "chat_123"

ScrollView {
    VStack(spacing: 0) {
        MessageBubble(
            message: ChatMessageModel(
                id: "1", author: "user_jamie", chatId: chatId,
                dateCreated: Date().addingTimeInterval(-300),
                message: "Hey! Did you catch the sunset last night? 🌅",
                readBy: [me, "user_jamie"]),
            currentUserId: me)

        MessageBubble(
            message: ChatMessageModel(
                id: "2", author: me, chatId: chatId,
                dateCreated: Date().addingTimeInterval(-240),
                message: "Yes it was absolutely incredible from my window",
                readBy: [me, "user_jamie"]),
            currentUserId: me)

        MessageBubble(
            message: ChatMessageModel(
                id: "3", author: "user_jamie", chatId: chatId,
                dateCreated: Date().addingTimeInterval(-180),
                message: "Next time we should watch from the rooftop 🍹",
                readBy: [me, "user_jamie"]),
            currentUserId: me)

        MessageBubble(
            message: ChatMessageModel(
                id: "4", author: me, chatId: chatId,
                dateCreated: Date(),
                message: "Saturday?",
                readBy: [me]),
            currentUserId: me)
    }
    .padding(.vertical)
}

}


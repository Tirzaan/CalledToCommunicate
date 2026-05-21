//
//  MultiPicker.swift
//  CalledToCommunicate
//
//  Created by Tirzaan on 4/17/26.
//

import SwiftUI

// T must be Hashable (String, Int, UUID, your model's ID, etc.)
struct MultiPicker<T: Hashable>: View {

    // Label shown next to each row
    let items: [T]
    let itemLabel: (T) -> String

    // Two-way binding to the caller's selection set
    @Binding var selection: Set<T>

    var body: some View {
        ForEach(items, id: \.self) { item in
            Button {
                if selection.contains(item) {
                    selection.remove(item)
                } else {
                    selection.insert(item)
                }
            } label: {
                HStack {
                    Text(itemLabel(item))
                        .foregroundStyle(.primary)
                    Spacer()
                    if selection.contains(item) {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.accent)
                    }
                }
            }
        }
    }
}

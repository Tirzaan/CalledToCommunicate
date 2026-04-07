//
//  ContentView.swift
//  CalledToCommunicate
//
//  Created by Tirzaan on 3/24/26.
//

import SwiftUI
import ExtentionsPlus

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Apple".withIndefiniteArticle())
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

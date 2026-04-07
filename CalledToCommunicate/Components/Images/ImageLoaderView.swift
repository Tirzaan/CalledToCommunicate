//
//  ImageLoaderView.swift
//  CalledToCommunicate
//
//  Created by Tirzaan on 3/26/26.
//


import SwiftUI
import SDWebImageSwiftUI

struct ImageLoaderView: View {
    var urlString: String
    var resizingMode: ContentMode
    
    init(_ urlString: String = Constants.image, resizingMode: ContentMode = .fill) {
        self.urlString = urlString
        self.resizingMode = resizingMode
    }
    
    var body: some View {
        Rectangle()
            .opacity(0.001)
            .overlay {
                WebImage(url: URL(string: urlString))
                    .resizable()
                    .indicator(.activity)
                    .aspectRatio(contentMode: resizingMode)
                    .allowsHitTesting(false)
            }
            .clipped()
    }
}

#Preview {
    ImageLoaderView()
        .frame(width: 100, height: 200)
}
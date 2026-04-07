//
//  SettingListCell.swift
//  CalledToCommunicate
//
//  Created by Tirzaan on 4/7/26.
//

import SwiftUI
import ExtentionsPlus

struct SettingListCell: View {
    var systemImage: String = "person.fill"
    var settingName: String = "Title"
    var action: () -> () = { }
    
    var body: some View {
        HStack {
            Image(systemName: systemImage)
            Text(settingName)
        }
        .asButton(.press) {
            action()
        }
    }
}

#Preview {
    SettingListCell()
}

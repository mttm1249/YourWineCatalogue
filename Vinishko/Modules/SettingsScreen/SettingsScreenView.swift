//
//  SettingsScreenView.swift
//  Vinishko
//
//  Created by mttm on 27.10.2023.
//

import SwiftUI

struct SettingsScreenView: View {
    var body: some View {
        VStack {
            SwitchButton(label: Localizable.SettingsScreenModule.sharePhoto, udKey: .photoShare)
            SwitchButton(label: Localizable.SettingsScreenModule.shareRating, udKey: .ratingShare)
            SwitchButton(label: Localizable.SettingsScreenModule.shareComment, udKey: .commentShare)
            Spacer()
        }
        .padding(.vertical)
        .navigationTitle(Localizable.SettingsScreenModule.settingsTitle).navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SettingsScreenView()
}

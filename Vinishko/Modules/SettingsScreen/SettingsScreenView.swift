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
            SwitchButton(label: "Делиться фото", udKey: .photoShare)
            SwitchButton(label: "Делиться рейтингом", udKey: .ratingShare)
            SwitchButton(label: "Делиться комментарием", udKey: .commentShare)
            Spacer()
        }
        .padding(.vertical)
        .navigationTitle("Настройки QR")
    }
}

#Preview {
    SettingsScreenView()
}

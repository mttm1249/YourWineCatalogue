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
            SwitchButton(buttonLabelText: "Делиться фото")
            SwitchButton(buttonLabelText: "Делиться рейтингом")
            SwitchButton(buttonLabelText: "Делиться комментарием")
            Spacer()
        }
        .padding(.vertical)
        .navigationTitle("Настройки QR")
    }
}

#Preview {
    SettingsScreenView()
}

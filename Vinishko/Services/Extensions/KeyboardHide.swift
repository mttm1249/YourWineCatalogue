//
//  KeyboardHide.swift
//  Vinishko
//
//  Created by mttm on 28.08.2023.
//

import SwiftUI

extension View {
    func hideKeyboard() -> some View {
        self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

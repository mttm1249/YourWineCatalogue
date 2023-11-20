//
//  TextEditorStandart.swift
//  Vinishko
//
//  Created by mttm on 29.08.2023.
//

import SwiftUI

struct TextEditorStandart: View {
    var header: String
    @Binding var text: String
    @FocusState private var isEditing: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(header)
                .font(Fonts.bold14)
                .foregroundColor(isEditing ? Pallete.borderColor : .gray)
            
            TextEditor(text: $text)
                .focused($isEditing)
                .frame(height: 80)
                .padding(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isEditing ? Pallete.borderColor : Color.gray, lineWidth: 1)
                )
        }
        .padding(.horizontal, 16)
    }
}

struct TextEditorStandart_Previews: PreviewProvider {
    static var previews: some View {
        TextEditorStandart(header: "Multiline", text: .constant(""))
    }
}

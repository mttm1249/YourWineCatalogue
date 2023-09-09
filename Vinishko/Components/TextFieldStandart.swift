//
//  TextFieldStandart.swift
//  Vinishko
//
//  Created by mttm on 04.07.2023.
//

import SwiftUI

struct TextFieldStandart: View {
    var header: String
    @Binding var text: String
    @State private var isEditing: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(header)
                .font(.system(size: 14)).bold()
                .foregroundColor(isEditing ? Pallete.borderColor : .gray)
            TextField("", text: $text, onEditingChanged: { editing in
                isEditing = editing
            })
            .frame(height: 20)
            .padding(6)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isEditing ? Pallete.borderColor : Color.gray, lineWidth: 1)
            )
        }
        .padding(.horizontal, 24)
    }
}

struct TextFieldStandart_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldStandart(header: "Header", text: .constant(""))
    }
}

//
//  SearchBarView.swift
//  Vinishko
//
//  Created by mttm on 30.08.2023.
//

import SwiftUI

struct SearchBarView: View {
  
    @Binding var text: String
  
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding(.leading, 8)
            TextField("Поиск", text: $text)
            Button(action: {
                self.text = ""
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
            }
            .opacity(text.isEmpty ? 0 : 1)
            .padding(.trailing, 8)
        }
        .frame(height: 36)
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .padding(.horizontal, 16)
    }
}

struct SearchBarView_Previews: PreviewProvider {
    @State static var text = ""

    static var previews: some View {
        SearchBarView(text: $text)
            .previewLayout(.sizeThatFits)
    }
}

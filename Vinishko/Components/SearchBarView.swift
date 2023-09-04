//
//  SearchBarView.swift
//  Vinishko
//
//  Created by mttm on 30.08.2023.
//

import SwiftUI

struct SearchBarView: View {
  
    @Binding var text: String
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding(.leading, 8)
                
                TextField("Поиск", text: $text, onEditingChanged: { editingChanged in
                    withAnimation {
                        self.isEditing = editingChanged
                    }
                })
                
                if isEditing && !text.isEmpty {
                    Button(action: {
                        self.text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 8)
                    .transition(.scale)
                }
                
            }
            .frame(height: 36)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal, 16)
            
            if isEditing {
                Button("Отменить") {
                    withAnimation {
                        self.isEditing = false
                        self.text = ""
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                }
                .padding(.trailing, 16)
                .transition(.move(edge: .trailing))
            }
        }
    }
}

struct SearchBarView_Previews: PreviewProvider {
    @State static var text = ""
    
    static var previews: some View {
        SearchBarView(text: $text)
            .previewLayout(.sizeThatFits)
    }
}

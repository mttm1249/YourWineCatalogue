//
//  OptionButtonView.swift
//  Vinishko
//
//  Created by mttm on 30.08.2023.
//

import SwiftUI

struct OptionButtonView: View {
    var header: String
    @Binding var text: String?
    var action: () -> Void

    var body: some View {
        VStack(alignment: .leading) {
            Text(header)
                .font(.system(size: 14)).bold()
                .foregroundColor(.gray)
            Button(action: action) {
                HStack {
                    Text(text ?? "")
                        .foregroundColor(Pallete.textColor)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .padding(.trailing, 8)
                }
            }
            .frame(height: 20)
            .padding(6)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
            )
        }
        .padding(.horizontal, 24)
    }
}

struct OptionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        OptionButtonView(header: "Страна", text: .constant("")) {
            print("Button Tapped")
        }
    }
}

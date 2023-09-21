//
//  InfoBubbles.swift
//  Vinishko
//
//  Created by mttm on 15.09.2023.
//

import SwiftUI

enum BorderStyle {
    case none
    case thick(Color)
    case thin(Color)
}

struct InfoBubbles: View {
    
    var header: String
    var content: [String]
    var firstItemBorderStyle: BorderStyle = .none
    
    private var filteredContent: [String] {
        return content.filter { !$0.isEmpty }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 8) {
                Text(header)
                    .font(.system(size: 14)).bold()
                    .foregroundColor(.gray)
                
                HStack(spacing: 8) {
                    ForEach(filteredContent.indices, id: \.self) { index in
                        let item = filteredContent[index]
                        let isFirst = index == 0

                        let borderStyle: (Color, CGFloat) = {
                            switch firstItemBorderStyle {
                            case .none:
                                return (Color.gray, 1)
                            case .thick(let color):
                                return (isFirst ? color : Color.gray, isFirst ? 2 : 1)
                            case .thin(let color):
                                return (isFirst ? color : Color.gray, 1)
                            }
                        }()
                        
                        Text(item)
                            .font(.system(size: 14))
                            .padding(.vertical, 5)
                            .padding(.horizontal, 12)
                            .overlay(
                                Capsule()
                                    .stroke(borderStyle.0, lineWidth: borderStyle.1)
                            )
                            .lineLimit(1)
                    }
                }
            }
            .padding(.horizontal, 16)
            Divider()
                .padding(.leading, 16)
        }
    }
}

struct InfoBubbles_Previews: PreviewProvider {
    static var previews: some View {
        InfoBubbles(header: "Описание", content: ["Красное", "Сухое", "Красное"], firstItemBorderStyle: .thick(.red))
    }
}

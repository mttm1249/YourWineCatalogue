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
    
    private struct Constants {
        static let contentFont = UIFont.systemFont(ofSize: 14)
        static let contentPadding: CGFloat = 5
        static let contentHorizontalPadding: CGFloat = 12
        static let contentSpacing: CGFloat = 8
        static let sidePadding: CGFloat = 16
        static let cornerRadius: CGFloat = 12
        static let maxWidth = UIScreen.main.bounds.width - 2 * sidePadding
    }
    
    var header: String
    var content: [String]
    var firstItemBorderStyle: BorderStyle = .none
    
    private var filteredContent: [String] {
        return content.filter { !$0.isEmpty }
    }
    
    private var contentRows: some View {
        var rows: [[String]] = [[]]
        var currentWidth: CGFloat = 0
        
        for i in filteredContent {
            let contentWidth = i.widthOfString(usingFont: Constants.contentFont) + 40
            
            if currentWidth + contentWidth > Constants.maxWidth {
                currentWidth = 0
                rows.append([])
            }
            
            rows[rows.count - 1].append(i)
            currentWidth += contentWidth
        }
        
        return ForEach(0..<rows.count, id: \.self) { rowIndex in
            HStack(spacing: Constants.contentSpacing) {
                ForEach(rows[rowIndex].indices, id: \.self) { index in
                    let item = rows[rowIndex][index]
                    
                    let borderStyle: (Color, CGFloat) = {
                        switch firstItemBorderStyle {
                        case .none:
                            return (Color.gray, 1)
                        case .thick(let color):
                            return (index == 0 ? color : Color.gray, index == 0 ? 2 : 1)
                        case .thin(let color):
                            return (index == 0 ? color : Color.gray, 1)
                        }
                    }()
                    
                    Text(item)
                        .font(Font(Constants.contentFont))
                        .padding(.vertical, Constants.contentPadding)
                        .padding(.horizontal, Constants.contentHorizontalPadding)
                        .overlay(
                            Capsule()
                                .stroke(borderStyle.0, lineWidth: borderStyle.1)
                        )
                        .lineLimit(1)
                }
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text(header)
                    .font(.system(size: 14)).bold()
                    .foregroundColor(.gray)
                contentRows
            }
            .padding(.horizontal, Constants.sidePadding)
            Divider()
                .padding(.leading, 16)
        }
    }
}

struct InfoBubbles_Previews: PreviewProvider {
    static var previews: some View {
        InfoBubbles(header: "Описание", content: ["Красное", "Сухое", ""], firstItemBorderStyle: .thick(.red))
    }
}

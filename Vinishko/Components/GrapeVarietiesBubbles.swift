//
//  GrapeVarietiesBubbles.swift
//  Vinishko
//
//  Created by mttm on 05.09.2023.
//

import SwiftUI

struct GrapeVarietiesBubbles: View {
    
    private struct Constants {
        static let tagFont = UIFont.systemFont(ofSize: 14)
        static let tagPadding: CGFloat = 8
        static let tagHorizontalPadding: CGFloat = 12
        static let tagSpacing: CGFloat = 8
        static let sidePadding: CGFloat = 16
        static let cornerRadius: CGFloat = 12
        static let maxWidth = UIScreen.main.bounds.width - 2 * sidePadding
    }

    var tags: [String]
   
    private var tagsRows: some View {
        var rows: [[String]] = [[]]
        var currentWidth: CGFloat = 0
        
        for tag in tags {
            let tagWidth = tag.widthOfString(usingFont: Constants.tagFont) + 40
            
            if currentWidth + tagWidth > Constants.maxWidth {
                currentWidth = 0
                rows.append([])
            }
            
            rows[rows.count - 1].append(tag)
            currentWidth += tagWidth
        }
        
        return ForEach(0..<rows.count, id: \.self) { rowIndex in
            HStack(spacing: Constants.tagSpacing) {
                ForEach(rows[rowIndex], id: \.self) { tag in
                    Text(tag)
                        .font(Font(Constants.tagFont))
                        .foregroundColor(Pallete.textColor)
                        .padding(.vertical, Constants.tagPadding)
                        .padding(.horizontal, Constants.tagHorizontalPadding)
                        .background(
                            RoundedRectangle(cornerRadius: 100)
                                .stroke(.gray, lineWidth: 0.5))
                        .lineLimit(1)
                }
            }
        }
    }

    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .fill(Pallete.searchBarBg)
            VStack(alignment: .leading, spacing: Constants.tagSpacing) {
                Text("Cорта")
                    .font(.system(size: 14)).bold()
                    .padding(.top, Constants.sidePadding)

                tagsRows

                Spacer()
            }
            .padding(.horizontal, Constants.sidePadding)
        }
        .padding(.horizontal, Constants.sidePadding)
    }
}

struct GrapeVarietiesBubbles_Previews: PreviewProvider {
    static var previews: some View {
        GrapeVarietiesBubbles(tags: ["Мерло", "Мальбек", "Гренаш", "Мерло", "Мальбек", "Гренаш", "Мерло", "Мальбек", "Гренаш", "Мерло"])
    }
}

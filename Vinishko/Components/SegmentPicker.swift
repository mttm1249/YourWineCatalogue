//
//  SegmentPicker.swift
//  Vinishko
//
//  Created by mttm on 29.08.2023.
//

import SwiftUI

struct SegmentedPicker: View {
    let titles: [String]
    let selectedItemColor = Color.clear
    let backgroundColor = Pallete.segmentPickerBg
    let selectedItemFontColor = Pallete.textColor
    let defaultItemFontColor = Color.gray
    let borderColor = Pallete.textColor
        
    @State private var segmentOffset: CGFloat = 0
    @Binding var selectedSegment: Int
        
    private func calculateOffset(geometry: GeometryProxy, selectedIndex: Int) -> CGFloat {
        return CGFloat(selectedIndex) * (geometry.size.width / CGFloat(titles.count)) + 1
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(selectedItemColor)
                    .frame(width: (geometry.size.width / CGFloat(titles.count)) - 2, height: 28)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(borderColor, lineWidth: 1))
                    .offset(x: segmentOffset)
                
                HStack {
                    ForEach(titles.indices, id: \.self) { index in
                        Button(action: {
                            withAnimation {
                                selectedSegment = index
                                segmentOffset = calculateOffset(geometry: geometry, selectedIndex: index)
                            }
                        }) {
                            Text(titles[index])
                                .font(.callout)
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .frame(height: 30)
                                .foregroundColor(selectedSegment == index ? selectedItemFontColor : defaultItemFontColor)
                        }
                    }
                }
            }
            .background(backgroundColor)
            .cornerRadius(8)
            .onAppear {
                segmentOffset = calculateOffset(geometry: geometry, selectedIndex: selectedSegment)
            }
        }
        .frame(height: 30)
        .padding(.horizontal, 24)
    }
    
}

struct SegmentedPickerView: View {
    var body: some View {
        VStack {
            Spacer()
            SegmentedPicker(titles: ["1", "2", "3"], selectedSegment: .constant(0))
            Spacer()
        }
    }
    
    struct SegmentedPicker_Previews: PreviewProvider {
        static var previews: some View {
            SegmentedPickerView()
        }
    }
}


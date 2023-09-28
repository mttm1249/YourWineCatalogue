//
//  Buttons.swift
//  Vinishko
//
//  Created by mttm on 04.07.2023.
//

import SwiftUI

struct NavigationButton<Destination: View>: View {
    var destination: Destination
    var imageName: String
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                Image(systemName: imageName)
            }
            .foregroundColor(.white)
            .frame(width: 150, height: 35)
            .background(Pallete.mainColor)
            .cornerRadius(10)
        }
    }
}

struct OptionButton: View {
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
                    Image(systemName: "chevron.down")
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

struct FilterButton: View {
    var header: String
    @Binding var selectedFilter: String?
    var action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(header)
                .font(.system(size: 14)).bold()
                .foregroundColor(.gray)
            
            HStack {
                if let text = selectedFilter, !text.isEmpty {
                    Button(action: {
                        HapticFeedbackService.generateFeedback(style: .light)
                        selectedFilter = nil
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                            .padding(.trailing, 8)
                    }
                }
                
                Button(action: action) {
                    HStack {
                        Text(selectedFilter ?? "")
                            .foregroundColor(Pallete.textColor)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .padding(.trailing, 8)
                    }
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

struct Buttons_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            NavigationButton(destination: NewBottleScreen(showSaveBanner: .constant(false)), imageName: "plus")
            NavigationButton(destination: NewBottleScreen(showSaveBanner: .constant(false)), imageName: "list.star")
            OptionButton(header: "Страна", text: .constant("")) {
                print("Button Tapped")
            }
            FilterButton(header: "Filter by", selectedFilter: .constant("")) {
                print("Button Tapped")
            }
        }
    }
}

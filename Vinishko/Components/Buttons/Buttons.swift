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

enum FilterButtonType {
    case string(Binding<String?>)
    case int(Binding<Int16?>)
}

struct FilterButton: View {
    var header: String
    var filterType: FilterButtonType
    var action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(header)
                .font(.system(size: 14)).bold()
                .foregroundColor(.gray)
            
            HStack {
                switch filterType {
                case .string(let selectedFilter):
                    if let text = selectedFilter.wrappedValue, !text.isEmpty {
                        Button(action: {
                            HapticFeedbackService.generateFeedback(style: .light)
                            selectedFilter.wrappedValue = nil
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(Pallete.mainColor)
                                .padding(.trailing, 8)
                        }
                    }
                case .int(let selectedFilter):
                    if LocalizationManager.shared.getWineType(selectedFilter.wrappedValue) != "" {
                        Button(action: {
                            HapticFeedbackService.generateFeedback(style: .light)
                            selectedFilter.wrappedValue = nil
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(Pallete.mainColor)
                                .padding(.trailing, 8)
                        }
                    }
                }
                
                Button(action: action) {
                    HStack {
                        switch filterType {
                        case .string(let selectedFilter):
                            Text(selectedFilter.wrappedValue ?? "")
                                .foregroundColor(Pallete.textColor)
                        case .int(let selectedFilter):
                            let wineTypeText = LocalizationManager.shared.getWineType(selectedFilter.wrappedValue)
                            Text(wineTypeText)
                                .foregroundColor(Pallete.textColor)
                        }
                        
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
            FilterButton(header: "Filter", filterType: .string(.constant("123"))) {
                print("123")
            }
        }
    }
}

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
                .font(Fonts.bold14)
                .foregroundColor(.gray)
            Button(action: {
                action()
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }) {
                HStack {
                    Text(text ?? "")
                        .foregroundColor(Pallete.textColor)
                    Spacer()
                    Image(systemName: Images.arrowDown)
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
        .padding(.horizontal, 16)
    }
}

struct CloseButton: View {
    var action: () -> Void

    var body: some View {
        HStack {
            Spacer()
            Button(Localizable.UIComponents.сloseButton) {
                action()
            }
        }
        .padding()
    }
}

enum FilterButtonType {
    case string(Binding<String?>)
    case wineTypeInt(Binding<Int16?>)
    case wineSugarInt(Binding<Int16?>)
    case countryCode(Binding<String?>)
}

struct FilterButton: View {
    var header: String
    var filterType: FilterButtonType
    var action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(header)
                .font(Fonts.bold14)
                .foregroundColor(.gray)
            
            HStack {
                switch filterType {
                case .string(let selectedFilter):
                    if let text = selectedFilter.wrappedValue, !text.isEmpty {
                        Button(action: {
                            HapticFeedbackService.generateFeedback(style: .light)
                            selectedFilter.wrappedValue = nil
                        }) {
                            Image(systemName: Images.xMark)
                                .foregroundColor(Pallete.mainColor)
                                .padding(.trailing, 8)
                        }
                    }
                case .wineTypeInt(let selectedFilter):
                    if LocalizationManager.shared.getWineType(selectedFilter.wrappedValue) != "" {
                        Button(action: {
                            HapticFeedbackService.generateFeedback(style: .light)
                            selectedFilter.wrappedValue = nil
                        }) {
                            Image(systemName: Images.xMark)
                                .foregroundColor(Pallete.mainColor)
                                .padding(.trailing, 8)
                        }
                    }
                case .countryCode(let selectedFilter):
                    if let text = selectedFilter.wrappedValue, !text.isEmpty {
                        Button(action: {
                            HapticFeedbackService.generateFeedback(style: .light)
                            selectedFilter.wrappedValue = nil
                        }) {
                            Image(systemName: Images.xMark)
                                .foregroundColor(Pallete.mainColor)
                                .padding(.trailing, 8)
                        }
                    }
                case .wineSugarInt(let selectedFilter):
                    if LocalizationManager.shared.getWineSugar(selectedFilter.wrappedValue) != "" {
                        Button(action: {
                            HapticFeedbackService.generateFeedback(style: .light)
                            selectedFilter.wrappedValue = nil
                        }) {
                            Image(systemName: Images.xMark)
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
                        case .wineTypeInt(let selectedFilter):
                            let wineTypeText = LocalizationManager.shared.getWineType(selectedFilter.wrappedValue)
                            Text(wineTypeText)
                                .foregroundColor(Pallete.textColor)
                        case .countryCode(let selectedFilter):
                            let wineCountryText = LocalizationManager.shared.getWineCountry(from: selectedFilter.wrappedValue)
                            Text(wineCountryText)
                                .foregroundColor(Pallete.textColor)
                        case .wineSugarInt(let selectedFilter):
                            let wineSugarText = LocalizationManager.shared.getWineSugar(selectedFilter.wrappedValue)
                            Text(wineSugarText)
                                .foregroundColor(Pallete.textColor)
                        }
                        
                        Spacer()
                        Image(systemName: Images.arrowDown)
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
        .padding(.horizontal, 16)
    }
}

struct SwitchButton: View {
    var label: String
    var udKey: UserDefaultsKey
    
    @State private var switchIsOn: Bool = false
    
    init(label: String, udKey: UserDefaultsKey) {
        self.label = label
        self.udKey = udKey
        _switchIsOn = State(initialValue: UserDefaults.standard.bool(forKey: udKey.rawValue))
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Toggle(label, isOn: $switchIsOn)
                    .toggleStyle(SwitchToggleStyle(tint: Pallete.redWineColor))
                    .onChange(of: switchIsOn) { newValue in
                        UserDefaults.standard.set(newValue, forKey: udKey.rawValue)
                    }
            }
            .padding(.horizontal, 16)
            Divider()
                .padding(.leading, 16)
        }
    }
}


#Preview {
    VStack {
        SwitchButton(label: "Делиться фото", udKey: .photoShare)
        SwitchButton(label: "Делиться рейтингом", udKey: .ratingShare)
        SwitchButton(label: "Делиться комментарием", udKey: .commentShare)
    }
}

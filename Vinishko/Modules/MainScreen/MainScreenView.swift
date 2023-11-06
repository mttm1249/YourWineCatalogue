//
//  MainScreenView.swift
//  Vinishko
//
//  Created by mttm on 04.07.2023.
//

import SwiftUI

struct MainScreenView: View {
    @State var showSaveBanner = false
    @State var offset: CGFloat = 300
    
    var body: some View {
        NavigationView {
            VStack(spacing: 25) {
                Spacer()
                Text("Vinishko")
                    .font(.title).bold()
                    .foregroundColor(Pallete.mainColor)
                    .padding(.bottom, 150)
                NavigationButton(destination:
                                    NewBottleScreen(viewModel: NewBottleViewModel(editableBottle: nil,
                                                   context: CoreDataManager.managedContext)),
                                 imageName: "plus")
                NavigationButton(destination: BottlesCatalogueView()
                    .environmentObject(BottlesCatalogueViewModel(context: CoreDataManager.managedContext)),
                                 imageName: "list.star")
                .padding(.bottom, 150)
                Spacer()
                if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
                   let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                    Text("Версия приложения: \(version), сборка: \(build)")
                        .font(.caption2)
                }
            }
            .overlay(
                VStack {
                    Spacer()
                    Text("Сохранено!")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.green)
                        .cornerRadius(15)
                        .offset(y: showSaveBanner ? 0 : offset)
                }
            )
            .onChange(of: showSaveBanner) { newValue in
                if newValue {
                    withAnimation {
                        offset = 0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        withAnimation {
                            offset = 300
                        }
                    }
                } else {
                    withAnimation {
                        offset = 300
                    }
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .didSaveBottleNotification)) { _ in
                withAnimation {
                    self.showSaveBanner = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        self.showSaveBanner = false
                    }
                }
            }
        }
    }
}

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView()
    }
}

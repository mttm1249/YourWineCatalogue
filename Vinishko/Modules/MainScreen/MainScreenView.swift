//
//  MainScreenView.swift
//  Vinishko
//
//  Created by mttm on 04.07.2023.
//

import SwiftUI

struct MainScreenView: View {
    @StateObject var viewModel = MainScreenViewModel()
    
    var body: some View {
        NavigationView {
            MainScreenAnimationView {
                VStack(spacing: 25) {
                    Spacer()
                    Text("Vinishko")
                        .font(.title).bold()
                        .foregroundColor(Pallete.mainColor)
                        .padding(.bottom, 150)
                    
                    NavigationButton(destination:
                                        NewBottleScreen(viewModel: NewBottleViewModel(editableBottle: nil,
                                                                                      context: CoreDataManager.managedContext)),
                                     imageName: Images.plus)
                    
                    NavigationButton(destination: BottlesCatalogueView()
                        .environmentObject(BottlesCatalogueViewModel(context: CoreDataManager.managedContext)),
                                     imageName: Images.listStar)
                    .padding(.bottom, 150)
                    
                    Spacer()
                    
                    // Версия и сборка приложения
                    if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                        Text("v. 2.0.\(build)")
                            .font(.caption2)
                            .foregroundStyle(.white)
                    }
                }
                .overlay(
                    VStack {
                        Spacer()
                        Text(Localizable.MainScreenModule.saved)
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(width: 200, height: 50)
                            .background(Color.green)
                            .cornerRadius(15)
                            .offset(y: viewModel.showSaveBanner ? 0 : viewModel.offset)
                    })
            }
        }
        .onAppear {
            viewModel.listenForSaveNotification()
        }
    }
}

#Preview {
        MainScreenView()
    }

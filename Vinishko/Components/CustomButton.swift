//
//  Buttons.swift
//  Vinishko
//
//  Created by mttm on 04.07.2023.
//

import SwiftUI

struct CustomButton<Destination: View>: View {
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

struct Buttons_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton(destination: NewBottleScreen(showSaveBanner: .constant(false)), imageName: "plus")
    }
}

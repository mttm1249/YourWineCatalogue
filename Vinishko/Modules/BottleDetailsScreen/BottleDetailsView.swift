//
//  BottleDetailsView.swift
//  Vinishko
//
//  Created by mttm on 29.08.2023.
//

import SwiftUI

struct BottleDetailsView: View {
    
    var bottle: Bottle
    
    var body: some View {
        VStack {
            Text(bottle.bottleDescription ?? "")
        }
        .navigationTitle(bottle.name ?? "")
    }
}

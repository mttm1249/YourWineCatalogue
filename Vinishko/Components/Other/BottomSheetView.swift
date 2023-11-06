//
//  BottomSheetView.swift
//  Vinishko
//
//  Created by mttm on 06.11.2023.
//


import SwiftUI

struct BottomSheet<Content: View>: View {
    
    @Binding var isShowing: Bool
    let content: Content
    
    init(isShowing: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._isShowing = isShowing
        self.content = content()
    }
    
    var body: some View {
        
        ZStack(alignment: .bottom) {
            if isShowing {
                Color.black
                    .opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isShowing.toggle()
                        }
                    }
                
                VStack(spacing: 20) {
                    // For fullscreen width
                    HStack {
                        Spacer()
                    }
                    
                    Capsule()
                        .frame(width: 40, height: 5)
                        .foregroundColor(Color.gray.opacity(0.5))
                    
                    content
                        .padding()
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                .frame(height: UIScreen.main.bounds.height / 2)
                .background(Pallete.bgColor)
                .cornerRadius(16)
                .gesture(
                    DragGesture().onEnded { value in
                        if value.translation.height > 50 {
                            withAnimation {
                                isShowing = false
                            }
                        }
                    }
                )
                .transition(.move(edge: .bottom))
            }
        }
        .ignoresSafeArea()
    }
}

//#Preview {
//}

//
//  FavoriteToggle.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 8/16/25.
//

import SwiftUI

struct FavoriteToggle: View {
    
    @Binding var isFavorite: Bool
    
    init(isFavorite: Binding<Bool>) {
        self._isFavorite = isFavorite
    }
    
    @State private var opacity: CGFloat = 0.5
    @State private var scale: CGFloat = 1
    @State private var offsetY: CGFloat = 0
   
    
    var body: some View {
        ZStack {
            Image(systemName: "heart.fill")
                .foregroundColor(.red)
                .font(.largeTitle)
                .opacity(opacity)
                .scaleEffect(scale)
                .offset(y: offsetY)
            
            Toggle(isOn: $isFavorite) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(isFavorite ? .red : .secondary)
                
            }
            .toggleStyle(.button)
            .buttonStyle(.plain)
            .animation(.spring, value: isFavorite)
            .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
            .onChange(of: isFavorite) { oldValue, newValue in
                guard newValue == true else {
                    return
                }
                
                // Appear and grow
                withAnimation(.spring(response: 0.5, dampingFraction: 0.4)) {
                    opacity = 1
                    scale = 1.2
                }
                
                // Float and vanish
                withAnimation(.easeInOut(duration: 0.5).delay(0.3)) {
                    offsetY = -100
                    opacity = 0
                    
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    scale = 1
                    offsetY = 0
                }
                
            }
        }
    }
}

#Preview {
    FavoriteToggle(isFavorite: .constant(false))
}

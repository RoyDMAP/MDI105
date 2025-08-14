//
//  StarRatingView.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 8/13/25.
//
import SwiftUI

struct StarRatingView: View {
    @Binding var rating: Int
    
    var body: some View {
        HStack {
            ForEach(1...5, id: \.self) { star in
                Button(action: {
                    rating = star
                }) {
                    Image(systemName: star <= rating ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                        .font(.title2)
                }
                .buttonStyle(.plain)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Star rating")
        .accessibilityValue("\(rating) out of 5 stars")
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment:
                if rating < 5 {
                    rating += 1
                }
            case .decrement:
                if rating > 0 {
                    rating -= 1
                }
            @unknown default:
                break
            }
        }
    }
}

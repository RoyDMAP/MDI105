//
//  SquareCardView.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 8/18/25.
//

import SwiftUI

struct SquareCardView: View {
    let book: Book
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            if !book.image.isEmpty {
                Image(book.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .clipped()
                    .cornerRadius(8)
            } else {
                // placeholder if no image
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 100, height: 100)
                    .overlay(
                        Image(systemName: "book.closed")
                            .font(.system(size: 30))
                            .foregroundColor(.gray)
                    )
                    .cornerRadius(8)
            }
            
            Text(book.title)
                .font(.headline)
                .fontWeight(.medium)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .foregroundColor(.primary)
                .frame(height: 44, alignment: .top)  
            
            Text(book.author)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(1)
                .frame(height: 20, alignment: .top)
            
            // Bottom section
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    CapsuleView(text: book.genre.rawValue, color: .cyan)
                    
                    Text(book.status.rawValue)
                        .font(.caption)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(4)
                }
                
                Spacer()
                
                if book.isFavorite {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            .frame(height: 40, alignment: .top)
            
            Spacer(minLength: 0)
        }
        .frame(width: 140, height: 220)
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .id(book.id)
        .accessibilityLabel("\"book.title) by \(book.author)")
        .accessibilityHint("Book in \(book.genre.rawValue) genre, currently \(book.status.rawValue)")
    }
}

#Preview {
    HStack {
        SquareCardView(book: Book(
            title: "Very Long Book Title That Goes On",
            author: "Very Long Author Name",
            image: "Pic1",
            description: "A sample book description",
            rating: 4,
            review: "Great book!",
            status: .finished,
            genre: .fantasy,
            isFavorite: true
        ))
        
        SquareCardView(book: Book(
            title: "Short",
            author: "Author",
            image: "",
            description: "Description",
            rating: 3,
            review: "Good",
            status: .reading,
            genre: .classic,
            isFavorite: false
        ))
    }
    .padding()
}
   

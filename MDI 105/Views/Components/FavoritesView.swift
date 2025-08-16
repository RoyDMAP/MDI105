//
//  FavoritesView.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 8/16/25.
//

import SwiftUI

struct FavoritesView: View {
    @Binding var books: [Book]
    
    var favoriteBooks: [Book] {
        books.filter { $0.isFavorite }
    }
    
    var body: some View {
        NavigationStack {
            if favoriteBooks.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "heart.slash")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    
                    Text("No Favorites Yet")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text("Tap the ❤️ on any book to add it to your favorites!")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .navigationTitle("Favorites")
                .navigationBarTitleDisplayMode(.large)
            } else {
                List(favoriteBooks) { book in
                    NavigationLink(destination: BookDetailView(book: binding(for: book))) {
                        LinkView(item: book)
                    }
                }
                .navigationTitle("Favorites")
                .navigationBarTitleDisplayMode(.large)
            }
        }
    }
    
    private func binding(for book: Book) -> Binding<Book> {
        guard let index = books.firstIndex(where: { $0.id == book.id }) else {
            fatalError("Book not found")
        }
        return $books[index]
    }
}

#Preview {
    FavoritesView(books: .constant([]))
}

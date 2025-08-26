//
//  FavoritesView.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 8/16/25.
//

import SwiftUI

struct FavoritesView: View {
    @Binding var books: [Book]
    @AppStorage(GRID_COLUMN_NUMBER_KEY) private var gridColumnNumber: Int = 2
    
    // Grid layout
    private var gridLayout: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: gridColumnNumber)
    }
    
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
                ScrollView {
                    LazyVGrid(columns: gridLayout, spacing: 16) {
                        ForEach(favoriteBooks) { book in
                            NavigationLink(destination: BookDetailView(
                                book: binding(for: book),
                                books: $books  
                            )) {
                                SquareCardView(book: book)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                }
                .navigationTitle("Favorite Books")
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
    FavoritesView(books: .constant([
        Book(
            title: "Sample Book",
            author: "Sample Author",
            image: "Pic1",
            description: "A sample book description",
            rating: 4,
            review: "Great book!",
            status: .finished,
            genre: .fantasy,
            isFavorite: true  // Moved to correct position
        ),
        Book(
            title: "Another Favorite",
            author: "Another Author",
            image: "Pic2",
            description: "Another great book",
            rating: 5,
            review: "Excellent read!",
            status: .finished,
            genre: .sciFi,
            isFavorite: true
        ),
        Book(
            title: "Not a Favorite",
            author: "Test Author",
            image: "Pic3",
            description: "This book is not favorited",
            rating: 3,
            status: .reading,
            genre: .mystery,
            isFavorite: false  
        )
    ]))
}

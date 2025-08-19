//
//  BookListView.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 8/16/25.
//

import SwiftUI

struct BookListView: View {
    @Binding var books: [Book]
    @Binding var selectedGenre: Genre?
    let filteredBooks: [Book]
    @Binding var showingAddBook: Bool
    @State private var showingGenreFilter = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredBooks) { book in
                    NavigationLink(destination: BookDetailView(
                        book: bindingForBook(book),
                        books: $books
                    )) {
                        BookRowView(book: book)
                    }
                }
                .onDelete(perform: deleteBooks)
            }
            .navigationTitle(navigationTitle)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showingGenreFilter = true
                    }) {
                        HStack {
                            Image(systemName: "line.3.horizontal.decrease.circle")
                            Text("Filter")
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddBook = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add Book")
                        }
                    }
                }
            }
            .sheet(isPresented: $showingGenreFilter) {
                GenreFilterView(
                    books: books,
                    selectedGenre: $selectedGenre
                )
            }
        }
    }
    
    private var navigationTitle: String {
        if let selectedGenre = selectedGenre {
            return selectedGenre.rawValue
        }
        return "My Books"
    }
    
    private func bindingForBook(_ book: Book) -> Binding<Book> {
        guard let index = books.firstIndex(where: { $0.id == book.id }) else {
            return .constant(book)
        }
        return $books[index]
    }
    
    func deleteBooks(at offsets: IndexSet) {
        let booksToDelete = offsets.map { filteredBooks[$0] }
        for bookToDelete in booksToDelete {
            books.removeAll { $0.id == bookToDelete.id }
        }
    }
}

struct BookRowView: View {
    let book: Book
    
    var body: some View {
        HStack {
            bookCoverView
            bookInfoView
            Spacer()
            favoriteIndicator
        }
        .padding(.vertical, 4)
    }
    
    @ViewBuilder
    private var bookCoverView: some View {
        if !book.image.isEmpty {
            Image(book.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 60)
                .cornerRadius(4)
        } else {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 40, height: 60)
                .overlay(
                    Image(systemName: "book.closed")
                        .foregroundColor(.gray)
                        .font(.caption)
                )
        }
    }
    
    private var bookInfoView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(book.title)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(2)
            
            Text(book.author)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack {
                CapsuleView(text: book.genre.rawValue, color: .cyan)
                CapsuleView(text: book.status.rawValue, color: .blue)
            }
        }
    }
    
    @ViewBuilder
    private var favoriteIndicator: some View {
        if book.isFavorite {
            Image(systemName: "heart.fill")
                .foregroundColor(.red)
        }
    }
}

#Preview {
    BookListView(
        books: .constant(getDefaultBooks()),
        selectedGenre: .constant(nil),
        filteredBooks: getDefaultBooks(),
        showingAddBook: .constant(false)
    )
}

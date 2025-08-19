//
//  ContentView.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 8/6/25.
//
import SwiftUI

struct ContentView: View {
    @State private var books: [Book] = []
    @State private var selectedGenre: Genre? = nil
    @State private var showingAddBook = false
    
    // Filtered books based on selected genre
    var filteredBooks: [Book] {
        if let selectedGenre = selectedGenre {
            return books.filter { $0.genre == selectedGenre }
        }
        return books
    }
    
    var body: some View {
        TabView {
            BookListView(
                books: $books,
                selectedGenre: $selectedGenre,
                filteredBooks: filteredBooks,
                showingAddBook: $showingAddBook
            )
            .tabItem {
                Label("My books", systemImage: "books.vertical.fill")
            }
            
            FavoritesView(books: $books)
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
        }
        .onAppear {
            if books.isEmpty {
                books = getDefaultBooks()
            }
        }
        .sheet(isPresented: $showingAddBook) {
            AddBookView(books: $books)
        }
    }
    
    
    func addBook(_ book: Book) {
        books.append(book)
    }
    
    
    func updateBook(_ updatedBook: Book) {
        if let index = books.firstIndex(where: { $0.id == updatedBook.id }) {
            books[index] = updatedBook
        }
    }
    
   
    func deleteBook(at index: Int) {
        guard index >= 0 && index < filteredBooks.count else { return }
        let bookToDelete = filteredBooks[index]
        books.removeAll { $0.id == bookToDelete.id }
    }
}

#Preview {
    ContentView()
}

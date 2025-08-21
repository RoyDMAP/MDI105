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
    @State private var searchText = ""
    @AppStorage(SETTINGS_THEME_KEY) private var theme: Theme = .system
    @AppStorage("appAccentColor") private var appAccentColor: Color = .blue
    
    var colorScheme: ColorScheme? {
        switch theme {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return nil
        }
    }
    
    // Search and filter books
    var searchedBooks: [Book] {
        if searchText.isEmpty {
            return books
        } else {
            return books.filter { book in
                book.title.localizedCaseInsensitiveContains(searchText) ||
                book.author.localizedCaseInsensitiveContains(searchText) ||
                book.genre.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var filteredBooks: [Book] {
        let searchFiltered = searchedBooks
        
        if let selectedGenre = selectedGenre {
            return searchFiltered.filter { $0.genre == selectedGenre }
        }
        return searchFiltered
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
                Label("My Books", systemImage: "books.vertical.fill")
            }
            
            FavoritesView(books: $books)
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
            
            SettingView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .searchable(text: $searchText, prompt: "Search books by title, author, or genre...")
        .preferredColorScheme(colorScheme)
        .tint(appAccentColor)
        .onAppear {
            loadBooksIfNeeded()
        }
        .sheet(isPresented: $showingAddBook) {
            AddBookView(books: $books)
        }
    }
    private func loadBooksIfNeeded() {
        if books.isEmpty {
            books = getDefaultBooks()
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
    
    func deleteBook(by id: UUID) {
        books.removeAll { $0.id == id }
    }
    
    func toggleFavorite(for bookId: UUID) {
        if let index = books.firstIndex(where: { $0.id == bookId }) {
            books[index].isFavorite.toggle()
        }
    }
    
    func updateBookStatus(_ bookId: UUID, status: BookStatus) {
        if let index = books.firstIndex(where: { $0.id == bookId }) {
            books[index].status = status
        }
    }
    
    func updateBookRating(_ bookId: UUID, rating: Int) {
        if let index = books.firstIndex(where: { $0.id == bookId }) {
            books[index].rating = rating
        }
    }
    //clear search
    func clearSearch() {
        searchText = ""
    }
    
    func hasSearchResults() -> Bool {
        return !filteredBooks.isEmpty || searchText.isEmpty
    }
    
    func getBooksCount() -> Int {
        return books.count
    }
    
    func getFavoritesCount() -> Int {
        return books.filter { $0.isFavorite }.count
    }
    
    func getBooksByStatus(_ status: BookStatus) -> [Book] {
        return books.filter { $0.status == status }
    }
    
    func getBooksByGenre(_ genre: Genre) -> [Book] {
        return books.filter { $0.genre == genre }
    }
    
    func getCurrentlyReadingBooks() -> [Book] {
        return getBooksByStatus(.reading)
    }
    
    func getFinishedBooks() -> [Book] {
        return getBooksByStatus(.finished)
    }
    
    func getNotStartedBooks() -> [Book] {
        return getBooksByStatus(.notStarted)
    }
}

#Preview {
    ContentView()
}

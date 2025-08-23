//
//  ContentView.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 8/6/25.
//
import SwiftUI

struct ContentView: View {
    @State private var books: [Book] = []
    @State private var selectedGenre: BookGenre? = nil
    @State private var showingAddBook = false
    @State private var searchText = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showingError = false
    @AppStorage(SETTINGS_THEME_KEY) private var theme: Theme = .system
    @AppStorage("appAccentColor") private var appAccentColorString: String = "blue"
    
    private let booksKey = "SavedBooks"
    
    // Convert string to Color
    private var appAccentColor: Color {
        AppColor(rawValue: appAccentColorString)?.color ?? AppColor.blue.color
    }
    
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
            // Books Tab
            NavigationStack {
                BookListView(
                    books: $books,
                    selectedGenre: $selectedGenre,
                    filteredBooks: filteredBooks,
                    showingAddBook: $showingAddBook
                )
            }
            .tabItem {
                Label("My Books", systemImage: "books.vertical.fill")
            }
            
            // Favorites Tab
            NavigationStack {
                FavoritesView(books: $books)
            }
            .tabItem {
                Label("Favorites", systemImage: "heart.fill")
            }
            
            // Settings Tab
            NavigationStack {
                SettingView()
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape")
            }
        }
        .searchable(text: $searchText, prompt: "Search books by title, author, or genre...")
        .preferredColorScheme(colorScheme)
        .tint(appAccentColor)
        .onAppear {
            loadBooks()
        }
        .onChange(of: books.count) { oldCount, newCount in
            if oldCount != newCount {
                saveBooks()
            }
        }
        .sheet(isPresented: $showingAddBook) {
            AddBookView(books: $books)
        }
        .alert("Error Loading Books", isPresented: $showingError) {
            Button("Try Again") {
                refreshBooks()
            }
            Button("Use Offline Data") {
                loadBooksFromStorage()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text(errorMessage ?? "An error occurred while loading books from the server.")
        }
    }
    
    private func loadBooks() {
        Task {
            await loadBooksFromAPI()
        }
    }
    
    private func loadBooksFromAPI() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        await MainActor.run {
            let apiBooks = getDefaultBooks()
          
            if !self.books.isEmpty {
                self.books = mergeBooks(apiBooks: apiBooks, localBooks: self.books)
            } else {
                self.books = apiBooks
            }
            
            self.isLoading = false
            self.saveBooks() // Save data locally
            print("Successfully loaded \(apiBooks.count) books from API")
        }
    }
    
    private func loadBooksFromStorage() {
        if let data = UserDefaults.standard.data(forKey: booksKey) {
            do {
                let decodedBooks = try JSONDecoder().decode([Book].self, from: data)
                books = decodedBooks
                print("Successfully loaded \(decodedBooks.count) books from storage")
            } catch {
                print("Error decoding books: \(error)")
                loadDefaultBooks()
            }
        } else {
            print("No saved books found")
            loadDefaultBooks()
        }
    }
    
    private func loadDefaultBooks() {
        books = getDefaultBooks()
    }
    
    private func saveBooks() {
        do {
            let encoded = try JSONEncoder().encode(books)
            UserDefaults.standard.set(encoded, forKey: booksKey)
            print("Successfully saved \(books.count) books")
        } catch {
            print("Error encoding books: \(error)")
        }
    }
    
    private func refreshBooks() {
        Task {
            await loadBooksFromAPI()
        }
    }
    
    // Merge API books with local books
    private func mergeBooks(apiBooks: [Book], localBooks: [Book]) -> [Book] {
        var mergedBooks: [Book] = []
        
        for apiBook in apiBooks {
            if let existingBook = localBooks.first(where: { $0.id == apiBook.id ||
                ($0.title == apiBook.title && $0.author == apiBook.author) }) {
                var mergedBook = apiBook
                mergedBook.id = existingBook.id // Keep the same ID
                mergedBook.isFavorite = existingBook.isFavorite
                mergedBook.rating = existingBook.rating
                mergedBook.status = existingBook.status
                mergedBooks.append(mergedBook)
            } else {
                // New book from API
                mergedBooks.append(apiBook)
            }
        }
        
        for localBook in localBooks {
            if !mergedBooks.contains(where: { $0.id == localBook.id }) {
                mergedBooks.append(localBook)
            }
        }
        
        return mergedBooks
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
    
    func updateBookStatus(_ bookId: UUID, to newStatus: BookReadingStatus) {
        if let index = books.firstIndex(where: { $0.id == bookId }) {
            books[index].status = newStatus
        }
    }
    
    func updateBookRating(_ bookId: UUID, rating: Int) {
        if let index = books.firstIndex(where: { $0.id == bookId }) {
            books[index].rating = rating
        }
    }
    
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
    
    func getBooksByStatus(_ status: BookReadingStatus) -> [Book] {
        return books.filter { $0.status == status }
    }
    
    func getBooksByGenre(_ genre: BookGenre) -> [Book] {
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

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
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showingError = false
    @State private var hasLoadedInitialData = false
    @AppStorage(SETTINGS_THEME_KEY) private var theme: Theme = .system
    @AppStorage("appAccentColor") private var appAccentColorString: String = "blue"
    
    private let booksKey = "SavedBooks"
    
    // Network service dependency injection
    private let networkService: NetworkServiceProtocol
    
    // Initializer for dependency injection
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    // Optimized computed property caching
    private var appAccentColor: Color {
        AppColor(rawValue: appAccentColorString)?.color ?? AppColor.blue.color
    }
    
    private var colorScheme: ColorScheme? {
        switch theme {
        case .light: .light
        case .dark: .dark
        case .system: nil
        }
    }
    
    // Optimized for more efficient filtering with early returns
    private var filteredBooks: [Book] {
        var result = books
        
        // Apply search filter first (potentially reduces dataset)
        if !searchText.isEmpty {
            let lowercasedSearch = searchText.lowercased()
            result = result.filter { book in
                book.title.lowercased().contains(lowercasedSearch) ||
                book.author.lowercased().contains(lowercasedSearch) ||
                book.genre.rawValue.lowercased().contains(lowercasedSearch)
            }
        }
        
        // Apply genre filter
        if let selectedGenre = selectedGenre {
            result = result.filter { $0.genre == selectedGenre }
        }
        
        return result
    }
    
    var body: some View {
        TabView {
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
            //Favorites
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
            // OPTIMIZATION: Remove redundant check
            guard !hasLoadedInitialData else { return }
            hasLoadedInitialData = true
            loadBooks()
        }
        // Optimized more targeted onChange
        .onChange(of: books) { _, _ in
            saveBooks()
        }
        .sheet(isPresented: $showingAddBook) {
            AddBookView(books: $books)
        }
        .alert("Error Loading Books", isPresented: $showingError) {
            Button("Try Again", action: refreshBooks)
            Button("Use Offline Data", action: loadBooksFromStorage)
            Button("Cancel", role: .cancel) { }
        } message: {
            Text(errorMessage ?? "An error occurred while loading books from the server.")
        }
    }
    
    // Updated load books using network service
    private func loadBooks() {
        loadBooksFromStorage()
        loadBooksFromNetwork()
    }
    
    // Updated to use NetworkService instead of direct async call
    private func loadBooksFromNetwork() {
        isLoading = true
        
        networkService.fetchBooks { result in
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(let apiBooks):
                    let mergedBooks = self.books.isEmpty ? apiBooks : self.mergeBooks(apiBooks: apiBooks, localBooks: self.books)
                    self.books = mergedBooks
                    print("Successfully loaded \(apiBooks.count) books from network service")
                    
                case .failure(let error):
                    self.errorMessage = "Failed to load books: \(error.localizedDescription)"
                    self.showingError = true
                    print("Network error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // Keep original async method for compatibility but rename
    @MainActor
    private func loadBooksFromAPI() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await Task.sleep(for: .seconds(1))
            let apiBooks = getDefaultBooks()
            
            books = books.isEmpty ? apiBooks : mergeBooks(apiBooks: apiBooks, localBooks: books)
            
            print("Successfully loaded \(apiBooks.count) books from API")
        } catch {
            errorMessage = "Failed to load books: \(error.localizedDescription)"
            showingError = true
        }
    }

    private func loadBooksFromStorage() {
        if let data = UserDefaults.standard.data(forKey: booksKey) {
            do {
                let decodedBooks = try JSONDecoder().decode([Book].self, from: data)
                
                withAnimation(.none) {
                    books = decodedBooks
                }
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
    
    // Optimized background encoding
    private func saveBooks() {
        let booksToSave = books // Capture current state
        
        Task.detached {
            do {
                let encoded = try JSONEncoder().encode(booksToSave)
                UserDefaults.standard.set(encoded, forKey: self.booksKey)
                
                await MainActor.run {
                    print("Successfully saved \(booksToSave.count) books to UserDefaults")
                }
            } catch {
                await MainActor.run {
                    print("Error encoding books: \(error)")
                }
            }
        }
    }
    
    private func refreshBooks() {
        loadBooksFromNetwork()
    }
    
    // Optimized efficient merging using Dictionary
    private func mergeBooks(apiBooks: [Book], localBooks: [Book]) -> [Book] {
        // Create lookup dictionary for faster searching
        let localBooksDict = Dictionary(uniqueKeysWithValues: localBooks.map { ($0.id, $0) })
        let localBooksByTitleAuthor = Dictionary(grouping: localBooks) { "\($0.title)-\($0.author)" }
            .compactMapValues { $0.first }
        
        var mergedBooks: [Book] = []
        var processedIds: Set<UUID> = []
        
        // Process API books first
        for apiBook in apiBooks {
            if let existingBook = localBooksDict[apiBook.id] ??
               localBooksByTitleAuthor["\(apiBook.title)-\(apiBook.author)"] {
                
                let mergedBook = Book(
                    id: existingBook.id,
                    title: apiBook.title,
                    author: apiBook.author,
                    image: apiBook.image,
                    description: apiBook.description,
                    rating: existingBook.rating,
                    review: existingBook.review,
                    status: existingBook.status,
                    genre: existingBook.genre,
                    isFavorite: existingBook.isFavorite
                )
                mergedBooks.append(mergedBook)
                processedIds.insert(existingBook.id)
            } else {
                mergedBooks.append(apiBook)
            }
        }
        
        // Add remaining local books that weren't merged
        for localBook in localBooks where !processedIds.contains(localBook.id) {
            mergedBooks.append(localBook)
        }
        
        return mergedBooks
    }
    
    // Optimized efficient CRUD operations
    func addBook(_ book: Book) {
        books.append(book)
        print("Added new book: \(book.title)")
    }
    
    func updateBook(_ updatedBook: Book) {
        guard let index = books.firstIndex(where: { $0.id == updatedBook.id }) else { return }
        books[index] = updatedBook
        print("Updated book: \(updatedBook.title) - Genre: \(updatedBook.genre.rawValue)")
    }
    
    func deleteBook(at index: Int) {
        guard filteredBooks.indices.contains(index) else { return }
        let bookToDelete = filteredBooks[index]
        books.removeAll { $0.id == bookToDelete.id }
        print("Deleted book: \(bookToDelete.title)")
    }
    
    func deleteBook(by id: UUID) {
        guard let book = books.first(where: { $0.id == id }) else { return }
        books.removeAll { $0.id == id }
        print("Deleted book: \(book.title)")
    }
    
    func toggleFavorite(for bookId: UUID) {
        guard let index = books.firstIndex(where: { $0.id == bookId }) else { return }
        books[index].isFavorite.toggle()
        print("Toggled favorite for: \(books[index].title) - isFavorite: \(books[index].isFavorite)")
    }
    
    func updateBookStatus(_ bookId: UUID, to newStatus: BookStatus) {
        guard let index = books.firstIndex(where: { $0.id == bookId }) else { return }
        books[index].status = newStatus
        print("Updated status for: \(books[index].title) - Status: \(newStatus.rawValue)")
    }
    
    func updateBookRating(_ bookId: UUID, rating: Int) {
        guard let index = books.firstIndex(where: { $0.id == bookId }) else { return }
        books[index].rating = rating
        print("Updated rating for: \(books[index].title) - Rating: \(rating)")
    }
    
    // Optimized Computed properties for statistics
    var searchResultsCount: Int { filteredBooks.count }
    var totalBooksCount: Int { books.count }
    var favoritesCount: Int { books.lazy.filter(\.isFavorite).count }
    
    func getBooksByStatus(_ status: BookStatus) -> [Book] {
        books.filter { $0.status == status }
    }
    
    func getBooksByGenre(_ genre: Genre) -> [Book] {
        books.filter { $0.genre == genre }
    }
}

#Preview("Production") {
    ContentView()
}

#Preview("With Mock Service") {
    let mockService = MockNetworkService()
    mockService.setupMockBooks([
        Book(title: "Mock Book 1", author: "Mock Author", image: "", description: "Mock description", rating: 5, review: "", status: .finished, genre: .fiction, isFavorite: true)
    ])
    
    return ContentView(networkService: mockService)
}

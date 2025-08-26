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
            if !hasLoadedInitialData {
                loadBooks()
                
            }
        }
        .onChange(of: books) { oldBooks, newBooks in
            saveBooks()
            print("Books array changed - saving to storage")
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
        loadBooksFromStorage()
        
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
            print("Successfully loaded \(apiBooks.count) books from API")
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
    
    private func saveBooks() {
        do {
            let encoded = try JSONEncoder().encode(books)
            UserDefaults.standard.set(encoded, forKey: booksKey)
            print("Successfully saved \(books.count) books to UserDefaults")
            
            // Debug
            for book in books.prefix(3) {
                print("Book: \(book.title) - Genre: \(book.genre.rawValue) - Status: \(book.status.rawValue)")
            }
        } catch {
            print("Error encoding books: \(error)")
        }
    }
    
    private func refreshBooks() {
        Task {
            await loadBooksFromAPI()
        }
    }
    
    private func mergeBooks(apiBooks: [Book], localBooks: [Book]) -> [Book] {
        var mergedBooks: [Book] = []
        
        for apiBook in apiBooks {
            if let existingBook = localBooks.first(where: { $0.id == apiBook.id ||
                ($0.title == apiBook.title && $0.author == apiBook.author) }) {
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
            } else {
                mergedBooks.append(apiBook)
            }
        }
        
        for localBook in localBooks {
            if !mergedBooks.contains(where: { $0.id == localBook.id }) {
                mergedBooks.append(localBook)
            }
        }
        let uniqueBooks = Dictionary(grouping: mergedBooks, by: { "\($0.title)-\($0.author)" })
            .compactMap { $0.value.first }
        
        return uniqueBooks
       
    }
    
    func addBook(_ book: Book) {
        books.append(book)
        print("Added new book: \(book.title)")
    }
    
    func updateBook(_ updatedBook: Book) {
        if let index = books.firstIndex(where: { $0.id == updatedBook.id }) {
            books[index] = updatedBook
            print("Updated book: \(updatedBook.title) - Genre: \(updatedBook.genre.rawValue)")
        }
    }
    
    func deleteBook(at index: Int) {
        guard index >= 0 && index < filteredBooks.count else { return }
        let bookToDelete = filteredBooks[index]
        books.removeAll { $0.id == bookToDelete.id }
        print("Deleted book: \(bookToDelete.title)")
    }
    
    func deleteBook(by id: UUID) {
        if let book = books.first(where: { $0.id == id }) {
            books.removeAll { $0.id == id }
            print("Deleted book: \(book.title)")
        }
    }
    
    func toggleFavorite(for bookId: UUID) {
        if let index = books.firstIndex(where: { $0.id == bookId }) {
            books[index].isFavorite.toggle()
            print("Toggled favorite for: \(books[index].title) - isFavorite: \(books[index].isFavorite)")
        }
    }
    
    func updateBookStatus(_ bookId: UUID, to newStatus: BookStatus) {
        if let index = books.firstIndex(where: { $0.id == bookId }) {
            books[index].status = newStatus
            print("Updated status for: \(books[index].title) - Status: \(newStatus.rawValue)")
        }
    }
    
    func updateBookRating(_ bookId: UUID, rating: Int) {
        if let index = books.firstIndex(where: { $0.id == bookId }) {
            books[index].rating = rating
            print("Updated rating for: \(books[index].title) - Rating: \(rating)")
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

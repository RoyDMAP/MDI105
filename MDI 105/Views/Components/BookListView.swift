//
//  BookListView.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 8/16/25.
//

import SwiftUI

struct BookListView: View {
    @Binding var books: [Book]
    @Binding var selectedGenre: BookGenre?
    let filteredBooks: [Book]
    @Binding var showingAddBook: Bool
    @State private var showingGenreFilter = false
    
    var body: some View {
        NavigationStack {
            if filteredBooks.isEmpty {
                emptyStateView
            } else {
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
            }
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
            Text("Genre Filter - Coming Soon")
                .padding()
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "book.closed")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Books Found")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Add your first book to get started!")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button(action: {
                showingAddBook = true
            }) {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Book")
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .padding()
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
            if let uiImage = UIImage.loadFromDocuments(filename: book.image) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 60)
                    .cornerRadius(4)
            } else if let bundleImage = UIImage(named: book.image) {
                // Fall back to bundle resources
                Image(uiImage: bundleImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 60)
                    .cornerRadius(4)
            } else {
                // Default placeholder
                defaultBookCover
            }
        } else {
            defaultBookCover
        }
    }
    
    private var defaultBookCover: some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color.gray.opacity(0.2))
            .frame(width: 40, height: 60)
            .overlay(
                Image(systemName: "book.closed")
                    .foregroundColor(.gray)
                    .font(.caption)
            )
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
                CapsuleView(text: book.genre.rawValue, color: genreColor(for: book.genre))
                CapsuleView(text: book.status.rawValue, color: statusColor(for: book.status))
            }
            
            if book.rating > 0 {
                HStack(spacing: 2) {
                    ForEach(1...5, id: \.self) { star in
                        Image(systemName: star <= book.rating ? "star.fill" : "star")
                            .font(.caption)
                            .foregroundColor(.yellow)
                    }
                }
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
    
    private func genreColor(for genre: BookGenre) -> Color {
        switch genre {
        case .classic: return .brown
        case .fantasy: return .purple
        case .terror: return .red
        case .dystopian: return .gray
        case .fiction: return .blue
        case .nonFiction: return .green
        case .mystery: return .indigo
        case .romance: return .pink
        case .sciFi: return .cyan
        case .biography: return .orange
        case .history: return .yellow
        }
    }
    
    private func statusColor(for status: BookReadingStatus) -> Color {
        switch status {
        case .notStarted: return .gray
        case .reading: return .blue
        case .finished: return .green
        case .planToRead: return .orange
        }
    }
}
// Extension for loading images from documents directory
extension UIImage {
    static func loadFromDocuments(filename: String) -> UIImage? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imageURL = documentsDirectory.appendingPathComponent("\(filename).jpg")
        
        if let imageData = try? Data(contentsOf: imageURL) {
            return UIImage(data: imageData)
        }
        return nil
    }
}

#Preview {
    BookListView(
        books: .constant([]),
        selectedGenre: .constant(nil),
        filteredBooks: [],
        showingAddBook: .constant(false)
    )
}

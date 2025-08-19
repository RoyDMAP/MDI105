//
//  EditView.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 8/11/25.
//

import SwiftUI

struct EditBookView: View {
    @Binding var book: Book
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String
    @State private var author: String
    @State private var image: String
    @State private var description: String
    @State private var rating: Int
    @State private var review: String
    @State private var status: BookStatus
    @State private var genre: Genre
    @State private var isFavorite: Bool
    
    init(book: Binding<Book>) {
        self._book = book
        
        // Initialize state variables with current book values
        self._title = State(initialValue: book.wrappedValue.title)
        self._author = State(initialValue: book.wrappedValue.author)
        self._image = State(initialValue: book.wrappedValue.image)
        self._description = State(initialValue: book.wrappedValue.description)
        self._rating = State(initialValue: book.wrappedValue.rating)
        self._review = State(initialValue: book.wrappedValue.review)
        self._status = State(initialValue: book.wrappedValue.status)
        self._genre = State(initialValue: book.wrappedValue.genre)
        self._isFavorite = State(initialValue: book.wrappedValue.isFavorite)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Book Information") {
                    TextField("Title", text: $title)
                    TextField("Author", text: $author)
                    TextField("Image Name (optional)", text: $image)
                }
                
                Section("Category") {
                    Picker("Genre", selection: $genre) {
                        ForEach(Genre.allCases, id: \.self) { genre in
                            HStack {
                                Circle()
                                    .fill(.cyan)  // Changed to light blue
                                    .frame(width: 12, height: 12)
                                Text(genre.rawValue)
                            }.tag(genre)
                        }
                    }
                    
                    Picker("Status", selection: $status) {
                        ForEach(BookStatus.allCases, id: \.self) { status in
                            Text(status.rawValue).tag(status)
                        }
                    }
                }
                
                Section("Details") {
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                    
                    // SIMPLIFIED: Only rating selector, no display
                    Picker("Rating", selection: $rating) {
                        Text("No Rating").tag(0)
                        Text("⭐ Poor").tag(1)
                        Text("⭐⭐ Fair").tag(2)
                        Text("⭐⭐⭐ Good").tag(3)
                        Text("⭐⭐⭐⭐ Very Good").tag(4)
                        Text("⭐⭐⭐⭐⭐ Excellent").tag(5)
                    }
                    .pickerStyle(.menu)
                }
                
                Section("Review (optional)") {
                    TextField("Your review", text: $review, axis: .vertical)
                        .lineLimit(2...4)
                }
                
                Section("Preferences") {
                    Toggle("Add to Favorites", isOn: $isFavorite)
                }
            }
            .navigationTitle("Edit Book")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveBook()
                    }
                    .disabled(title.isEmpty || author.isEmpty)
                }
            }
        }
    }
    
    private func genreColor(for genre: Genre) -> Color {
        return .cyan
    }
    
    
    private var ratingDescription: String {
        switch rating {
        case 1: return "Poor"
        case 2: return "Fair"
        case 3: return "Good"
        case 4: return "Very Good"
        case 5: return "Excellent"
        default: return ""
        }
    }
    
    private func saveBook() {
        book.title = title
        book.author = author
        book.image = image
        book.description = description
        book.rating = rating
        book.review = review
        book.status = status
        book.genre = genre
        book.isFavorite = isFavorite
        
        dismiss()
    }
}

#Preview {
    EditBookView(
        book: .constant(Book(
            title: "Sample Book",
            author: "Sample Author",
            image: "Pic1",
            description: "A sample description",
            rating: 4,
            review: "Great book!",
            isFavorite: false,
            status: .finished,
            genre: .fantasy
        ))
    )
}

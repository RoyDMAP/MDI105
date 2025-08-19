//
//  AddBookView.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 8/18/25.
//

import SwiftUI

struct AddBookView: View {
    @Binding var books: [Book]  // Direct binding to books array
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var author = ""
    @State private var image = ""
    @State private var description = ""
    @State private var rating = 0
    @State private var review = ""
    @State private var status = BookStatus.notStarted
    @State private var genre = Genre.classic
    
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
                                    .fill(genreColor(for: genre))
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
                    
                    HStack {
                        Text("Rating")
                        Spacer()
                        ForEach(1...5, id: \.self) { star in
                            Button(action: {
                                rating = star
                            }) {
                                Image(systemName: star <= rating ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                            }
                        }
                    }
                }
                
                Section("Review (optional)") {
                    TextField("Your review", text: $review, axis: .vertical)
                        .lineLimit(2...4)
                }
            }
            .navigationTitle("Add Book")
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
        switch genre {
        case .classic: return .brown
        case .fantasy: return .purple
        case .terror: return .red
        case .dystopian: return .gray
        }
    }
    
    private func saveBook() {
        let newBook = Book(
            title: title,
            author: author,
            image: image,
            description: description,
            rating: rating,
            review: review,
            isFavorite: false,
            status: status,
            genre: genre
        )
        
        books.append(newBook)  
        dismiss()
    }
}

#Preview {
    AddBookView(books: .constant([]))
}

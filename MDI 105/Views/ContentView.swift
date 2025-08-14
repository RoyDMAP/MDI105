//
//  ContentView.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 8/6/25.
//
import SwiftUI

struct ContentView: View {
    @State private var books: [Book] = {
        let books = getBooks()
        print("Loaded \(books.count) books")
        return books
    }()
    
    @State private var showingAddSheet = false
    
    // Add book form states
    @State private var newTitle = ""
    @State private var newAuthor = ""
    @State private var newDescription = ""
    @State private var newImage = "book"
    @State private var newRating = 3
    @State private var newReview = ""
    @State private var newStatus: BookStatus = .notStarted
    
    var body: some View {
        NavigationView {
            List(books) { currentItem in
                NavigationLink(destination: BookDetailView(book: binding(for: currentItem))) {
                    LinkView(item: currentItem)
                }
            }
            .navigationTitle("My Books")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        resetAddForm()
                        showingAddSheet = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 32, height: 32)
                            .background(Color.accentColor)
                            .clipShape(Circle())
                    }
                    .padding(.trailing, 8)
                }
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            NavigationView {
                Form {
                    Section("Book Details") {
                        TextField("Title", text: $newTitle)
                        TextField("Author", text: $newAuthor)
                        TextField("Description", text: $newDescription, axis: .vertical)
                            .lineLimit(3...6)
                    }
                    
                    Section("Image") {
                        TextField("Image Name", text: $newImage)
                        Text("Use SF Symbol names like 'book', 'book.fill', etc.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Section("Rating") {
                        StarRatingView(rating: $newRating)
                    }
                    
                    Section("Review") {
                        TextField("Your review", text: $newReview, axis: .vertical)
                            .lineLimit(2...4)
                    }
                    
                    Section("Status") {
                        Picker("Reading Status", selection: $newStatus) {
                            ForEach(BookStatus.allCases, id: \.self) { status in
                                Text(status.rawValue).tag(status)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }
                .navigationTitle("Add New Book")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            showingAddSheet = false
                        }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            addNewBook()
                            showingAddSheet = false
                        }
                        .disabled(newTitle.isEmpty && newAuthor.isEmpty)
                    }
                }
            }
        }
    }
    
    private func binding(for book: Book) -> Binding<Book> {
        guard let index = books.firstIndex(where: { $0.id == book.id }) else {
            fatalError("Book not found")
        }
        return $books[index]
    }
    
    private func addNewBook() {
        let newBook = Book(
            title: newTitle.isEmpty ? "Untitled Book" : newTitle,
            author: newAuthor.isEmpty ? "Unknown Author" : newAuthor,
            image: newImage.isEmpty ? "book" : newImage,
            description: newDescription.isEmpty ? "No description available." : newDescription,
            rating: newRating,
            review: newReview.isEmpty ? "No review yet." : newReview,
            status: newStatus
        )
        books.append(newBook)
        print("Added new book: \(newBook.title)")
    }
    
    private func resetAddForm() {
        newTitle = ""
        newAuthor = ""
        newDescription = ""
        newImage = "book"
        newRating = 3
        newReview = ""
        newStatus = .notStarted
    }
}
#Preview {
    ContentView()
}

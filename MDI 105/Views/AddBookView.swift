//
//  AddBookView.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 8/18/25.
//

import SwiftUI
import PhotosUI

struct AddBookView: View {
    @Binding var books: [Book]  // binding to books array
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var author = ""
    @State private var image = ""
    @State private var description = ""
    @State private var rating = 0
    @State private var review = ""
    @State private var status = BookStatus.notStarted
    @State private var genre = Genre.classic
    @State private var bookImage: UIImage?
    @State private var photoPickerItem: PhotosPickerItem?
    
    var body: some View {
        NavigationStack {
            Form {
                // Book Cover Section
                Section("Book Cover") {
                    PhotosPicker(
                        selection: $photoPickerItem,
                        matching: .images
                    ) {
                        if let bookImage = bookImage {
                            Image(uiImage: bookImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 120, height: 160)
                                .cornerRadius(8)
                        } else {
                            VStack {
                                Image(systemName: "photo")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                                Text("Tap to add cover image")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .frame(width: 120, height: 160)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                    .onChange(of: photoPickerItem) { _, _ in
                        Task {
                            if let photoPickerItem,
                               let imageData = try? await photoPickerItem.loadTransferable(type: Data.self) {
                                if let uiImage = UIImage(data: imageData) {
                                    self.bookImage = uiImage
                                    self.image = "book_cover_\(UUID().uuidString)"
                                }
                            }
                        }
                    }
                    
                    if bookImage != nil {
                        Button("Remove Image") {
                            bookImage = nil
                            photoPickerItem = nil
                            image = ""
                        }
                        .foregroundColor(.red)
                    }
                }
                
                Section("Book Information") {
                    TextField("Title", text: $title)
                    TextField("Author", text: $author)
                    TextField("Image Name (optional)", text: $image)
                        .disabled(bookImage != nil)
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
        case .fiction: return .blue
        case .nonFiction: return .green
        case .mystery: return .indigo
        case .romance: return .pink
        case .sciFi: return .cyan
        case .biography: return .orange
        case .history: return .yellow
        }
    }
    
    private func saveBook() {
        var finalImageName = image
        
        if let bookImage = bookImage {
            // Save the image to documents directory
            let imageName = image.isEmpty ? "book_cover_\(UUID().uuidString)" : image
            saveImageToDocuments(bookImage, filename: imageName)
            finalImageName = imageName
        }
        
        let newBook = Book(
            title: title,
            author: author,
            image: finalImageName,
            description: description,
            rating: rating,
            review: review,
            status: status,
            genre: genre,
            isFavorite: false
        )
        
        books.append(newBook)
        dismiss()
    }
    
    private func saveImageToDocuments(_ image: UIImage, filename: String) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else { return }
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imageURL = documentsDirectory.appendingPathComponent("\(filename).jpg")
        
        do {
            try imageData.write(to: imageURL)
            print("Image saved to: \(imageURL)")
        } catch {
            print("Error saving image: \(error)")
        }
    }
}

#Preview {
    AddBookView(books: .constant([]))
}

//
//  EditView.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 8/11/25.
//

import SwiftUI
import PhotosUI

struct EditBookView: View {
    @Binding var book: Book
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String
    @State private var author: String
    @State private var image: String
    @State private var description: String
    @State private var rating: Int
    @State private var review: String
    @State private var status: BookReadingStatus
    @State private var genre: BookGenre
    @State private var isFavorite: Bool
    @State private var bookImage: UIImage?
    @State private var photoPickerItem: PhotosPickerItem?
    
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
                bookCoverSection
                bookInformationSection
                categorySection
                detailsSection
                reviewSection
                preferencesSection
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
    
    private var bookCoverSection: some View {
        Section(header: Text("Book cover")) {
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
                } else if !book.image.isEmpty {

                    if let existingImage = loadImageFromDocuments(filename: book.image) {
                        Image(uiImage: existingImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 160)
                            .cornerRadius(8)
                    } else if let bundleImage = UIImage(named: book.image) {
                        Image(uiImage: bundleImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 160)
                            .cornerRadius(8)
                    } else {
                        defaultImagePlaceholder
                    }
                } else {
                    defaultImagePlaceholder
                }
            }
            .onChange(of: photoPickerItem) { _, _ in
                Task {
                    if let photoPickerItem,
                       let imageData = try? await photoPickerItem.loadTransferable(type: Data.self) {
                        if let uiImage = UIImage(data: imageData) {
                            self.bookImage = uiImage
                            // Generate a unique filename for the new image
                            self.image = "book_cover_\(UUID().uuidString)"
                        }
                    }
                }
            }
            
            if bookImage != nil {
                Button("Remove New Image") {
                    bookImage = nil
                    photoPickerItem = nil
                    // Keep original image name if reverting
                    image = book.image
                }
                .foregroundColor(.red)
            }
        }
    }
    
    private var defaultImagePlaceholder: some View {
        VStack {
            Image(systemName: "photo")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            Text("Tap to change cover image")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(width: 120, height: 160)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
    
    private var bookInformationSection: some View {
        Section("Book Information") {
            TextField("Title", text: $title)
            TextField("Author", text: $author)
            TextField("Image Name (optional)", text: $image)
                .disabled(bookImage != nil) // Disable if new image was selected
        }
    }
    
    private var categorySection: some View {
        Section("Category") {
            Picker("Genre", selection: $genre) {
                ForEach(BookGenre.allCases, id: \.self) { genre in  // Changed from Genre.allCases
                    HStack {
                        Circle()
                            .fill(genreColor(for: genre))
                            .frame(width: 12, height: 12)
                        Text(genre.rawValue)
                    }.tag(genre)
                }
            }
            
            Picker("Status", selection: $status) {
                ForEach(BookReadingStatus.allCases, id: \.self) { status in  // Changed from BookStatus.allCases
                    Text(status.rawValue).tag(status)
                }
            }
        }
    }
    
    private var detailsSection: some View {
        Section("Details") {
            TextField("Description", text: $description, axis: .vertical)
                .lineLimit(3...6)
            
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
    }
    
    private var reviewSection: some View {
        Section("Review (optional)") {
            TextField("Your review", text: $review, axis: .vertical)
                .lineLimit(2...4)
        }
    }
    
    private var preferencesSection: some View {
        Section("Preferences") {
            Toggle("Add to Favorites", isOn: $isFavorite)
        }
    }
    
    private func genreColor(for genre: BookGenre) -> Color {  // Changed parameter type
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
    
    private func loadImageFromDocuments(filename: String) -> UIImage? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imageURL = documentsDirectory.appendingPathComponent("\(filename).jpg")
        
        if let imageData = try? Data(contentsOf: imageURL) {
            return UIImage(data: imageData)
        }
        return nil
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
    
    private func saveBook() {
        var finalImageName = image
        
        if let bookImage = bookImage {
            // Save the new image to documents directory
            let imageName = image.isEmpty ? "book_cover_\(UUID().uuidString)" : image
            saveImageToDocuments(bookImage, filename: imageName)
            finalImageName = imageName
        }
        book.title = title
        book.author = author
        book.image = finalImageName
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

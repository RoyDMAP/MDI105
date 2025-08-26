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
    
    @State private var title: String = ""
    @State private var author: String = ""
    @State private var image: String = ""
    @State private var description: String = ""
    @State private var rating: Int = 0
    @State private var review: String = ""
    @State private var status: BookStatus = .notStarted
    @State private var genre: Genre = .fiction
    @State private var isFavorite: Bool = false
    @State private var bookImage: UIImage?
    @State private var photoPickerItem: PhotosPickerItem?
    
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
            .onAppear {
    
                initializeState()
            }
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
    
    private func initializeState() {
        title = book.title
        author = book.author
        image = book.image
        description = book.description
        rating = book.rating
        review = book.review
        status = book.status
        genre = book.genre
        isFavorite = book.isFavorite
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
                .disabled(bookImage != nil)
        }
    }
    
    private var categorySection: some View {
        Section("Category") {
            VStack(alignment: .leading, spacing: 8) {
                Text("Current Genre: \(genre.rawValue)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Picker("Genre", selection: $genre) {
                    ForEach(Genre.allCases, id: \.self) { genreOption in
                        HStack {
                            Circle()
                                .fill(genreColor(for: genreOption))
                                .frame(width: 12, height: 12)
                            Text(genreOption.rawValue)
                        }
                        .tag(genreOption)
                    }
                }
                .pickerStyle(.menu)
                .onChange(of: genre) { oldValue, newValue in
                    print("Genre changed from \(oldValue.rawValue) to \(newValue.rawValue)")
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Current Status: \(status.rawValue)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Picker("Status", selection: $status) {
                    ForEach(BookStatus.allCases, id: \.self) { statusOption in
                        Text(statusOption.rawValue)
                            .tag(statusOption)
                    }
                }
                .pickerStyle(.menu)
                .onChange(of: status) { oldValue, newValue in
                    print("Status changed from \(oldValue.rawValue) to \(newValue.rawValue)")
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
            let imageName = image.isEmpty ? "book_cover_\(UUID().uuidString)" : image
            saveImageToDocuments(bookImage, filename: imageName)
            finalImageName = imageName
        }
        
        print("=== SAVE DEBUG ===")
        print("Before save - Local genre: \(genre.rawValue)")
        print("Before save - Local status: \(status.rawValue)")
        print("Before save - Book genre: \(book.genre.rawValue)")
        print("Before save - Book status: \(book.status.rawValue)")
        
        book.title = title
        book.author = author
        book.image = finalImageName
        book.description = description
        book.rating = rating
        book.review = review
        book.status = status
        book.genre = genre
        book.isFavorite = isFavorite
        
        print("After save - Book genre: \(book.genre.rawValue)")
        print("After save - Book status: \(book.status.rawValue)")
        print("==================")
        
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
            status: .finished,
            genre: .fantasy,
            isFavorite: false  
        ))
    )
}

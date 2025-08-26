//
//  DetailView.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 8/6/25.
//
import SwiftUI

struct BookDetailView: View {
    @Binding var book: Book
    @Binding var books: [Book]
    @State private var showingEditSheet = false
    @State private var showingDeleteAlert = false
    @Environment(\.dismiss) private var dismiss
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            backgroundGradient
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    bookCoverSection
                    bookInfoSection
                    ratingAndFavoriteSection
                    genreAndStatusSection
                    descriptionSection
                    reviewSection
                    actionButtonsSection
                  
                    Spacer()
                }
                .padding()
            }
        }
        .navigationTitle(book.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button("Edit") {
                        showingEditSheet = true
                    }
                    
                    Button(action: {
                        showingDeleteAlert = true
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            EditBookView(book: $book)
        }
        .alert("Delete Book", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                deleteBook()
            }
        } message: {
            Text("Are you sure you want to delete \"\(book.title)\"? This action cannot be undone.")
        }
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [.green.opacity(0.1), .white.opacity(0.3)]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
    
    private var bookCoverSection: some View {
        Group {
            if !book.image.isEmpty {
                Image(book.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 250)
                    .cornerRadius(10)
                    .accessibilityLabel("\(book.title) cover image")
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 250)
                    .overlay(
                        Image(systemName: "book.closed")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                    )
            }
        }
    }
    
    private var bookInfoSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(book.title)
                .font(.title)
                .fontWeight(.bold)
            
            Text("by \(book.author)")
                .font(.title2)
                .foregroundColor(.secondary)
        }
    }
    
    private var ratingAndFavoriteSection: some View {
        HStack {
            ForEach(1...5, id: \.self) { star in
                Image(systemName: star <= book.rating ? "star.fill" : "star")
                    .foregroundColor(.yellow)
                    .font(.title3)
            }
            Text("(\(book.rating)/5)")
                .foregroundColor(.secondary)
            
            Spacer()
            
            // Heart button: Click to like, click again to clear like
            Button(action: {
                let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                impactFeedback.impactOccurred()
                
                // Toggle the favorite state with animation
                withAnimation(.easeInOut(duration: 0.2)) {
                    book.isFavorite.toggle()
                }
            }) {
                Image(systemName: book.isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(book.isFavorite ? .red : .gray)
                    .font(.title2)
                    .scaleEffect(book.isFavorite ? 1.15 : 1.0)
                    .opacity(book.isFavorite ? 1.0 : 0.8)
            }
            .buttonStyle(.plain)
            .frame(width: 44, height: 44)
            .contentShape(Rectangle())
            .accessibilityLabel("\(book.rating) out of 5 stars. \(book.isFavorite ? "Favorited" : "Not favorited")")
            .accessibilityHint(book.isFavorite ? "Tap to remove from favorites" : "Tap to add to favorites")
        }
    }
    private var genreAndStatusSection: some View {
        HStack {
            CapsuleView(text: book.genre.rawValue, color: .cyan)
            CapsuleView(text: book.status.rawValue, color: .blue)
            Spacer()
        }
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Description")
                .font(.headline)
                .padding(.top)
            
            Text(book.description)
                .font(.body)
                .foregroundColor(.primary)
        }
    }
    
    @ViewBuilder
    private var reviewSection: some View {
        if !book.review.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text("Review")
                    .font(.headline)
                    .padding(.top)
                
                Text(book.review)
                    .font(.body)
                    .foregroundColor(.primary)
                    .italic()
            }
        }
    }
    
    private var actionButtonsSection: some View {
        VStack(spacing: 12) {
            if book.status != .finished {
                Button("Mark as Read") {
                    book.status = .finished
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
            }
            
            if book.status != .reading && book.status != .finished {
                Button("Start Reading") {
                    book.status = .reading
                }
                .buttonStyle(.bordered)
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.top)
    }
    
    // Delete function
    private func deleteBook() {
        books.removeAll { $0.id == book.id }
        dismiss()
    }
}



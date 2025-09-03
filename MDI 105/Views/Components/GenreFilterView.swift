//
//  FilterView.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 9/1/25.
//

import SwiftUI

struct GenreFilterView: View {
    let books: [Book]
    @Binding var selectedGenre: Genre?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                allBooksSection
                genresSection
                cancelSection
            }
            .navigationTitle("Filter by Genre")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var allBooksSection: some View {
        Section {
            AllBooksRow(
                totalBooks: books.count,
                isSelected: selectedGenre == nil,
                action: {
                    selectedGenre = nil
                    dismiss()
                }
            )
        } header: {
            Text("Filter Options")
        }
    }
    
    private var genresSection: some View {
        Section {
            ForEach(Genre.allCases, id: \.self) { genre in
                GenreRow(
                    genre: genre,
                    books: books,
                    isSelected: selectedGenre == genre,
                    action: {
                        selectedGenre = genre
                        dismiss()
                    }
                )
            }
        } header: {
            Text("Genres")
        }
    }
    
    private var cancelSection: some View {
        Section {
            Button(action: {
                dismiss()
            }) {
                Text("Cancel")
                    .foregroundColor(.red)
            }
        }
    }
}

struct AllBooksRow: View {
    let totalBooks: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text("All Books")
                    .foregroundColor(.primary)
                Spacer()
                Text("\(totalBooks)")
                    .foregroundColor(.secondary)
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

struct GenreRow: View {
    let genre: Genre
    let books: [Book]
    let isSelected: Bool
    let action: () -> Void
    
    private var booksInGenre: [Book] {
        books.filter { $0.genre == genre }
    }
    
    private var genreColor: Color {
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
    
    var body: some View {
        if !booksInGenre.isEmpty {
            Button(action: action) {
                HStack {
                    Circle()
                        .fill(genreColor)
                        .frame(width: 12, height: 12)
                    
                    Text(genre.rawValue)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Text("\(booksInGenre.count)")
                        .foregroundColor(.secondary)
                    
                    if isSelected {
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
    }
}

#Preview {
    GenreFilterView(
        books: [],
        selectedGenre: .constant(nil)
    )
}

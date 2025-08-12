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
    
    var body: some View {
        NavigationView {
            List(books) { currentItem in
                NavigationLink(destination: BookDetailView(book: binding(for: currentItem))) {
                    LinkView(item: currentItem)
                }
            }
            .navigationTitle("LOTR Trilogy")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private func binding(for book: Book) -> Binding<Book> {
        guard let index = books.firstIndex(where: { $0.id == book.id }) else {
            fatalError("Book not found")
        }
        return $books[index]
    }
}

#Preview {
    ContentView()
}

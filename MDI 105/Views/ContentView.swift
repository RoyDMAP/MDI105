//
//  ContentView.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 8/6/25.
//
import SwiftUI

struct ContentView: View {
    
    @State private var books: [Book] = getBooks()
    
    var body: some View {
        TabView {
            BookListView(books: $books)
                .tabItem {
                    Label("My books", systemImage: "books.vertical.fill")
                }
            FavoritesView(books: $books)
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}



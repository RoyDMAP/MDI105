//
//  ContentView.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 8/6/25.
//

import SwiftUI

struct Book: Identifiable, Hashable {
    let id = UUID() // Automatic and unique
    let title: String
    let image: String
    let description: String
}

struct ContentView: View {
    let books: [Book] = getItems()
    
    var body: some View {
        NavigationView {
            List(books) { currentItem in
                NavigationLink(destination: detailView(book: currentItem)) {
                    LinkView(item: currentItem)
                }
            }
            .navigationTitle("LOTR Trilogy")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}

//
//  DetailView.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 8/6/25.
//

import SwiftUI

struct BookDetailView: View {
    let book: Book
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Image(book.image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .cornerRadius(10)
                
                Text(book.title)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("by \(book.author)")
                    .font(.title2)
                    .foregroundColor(.secondary)
                
                Text(book.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(book.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
#Preview {
    ContentView()
    
}

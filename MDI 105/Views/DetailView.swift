//
//  DetailView.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 8/6/25.
//
import SwiftUI

struct BookDetailView: View {
    @Binding var book: Book
    @State private var showingEditSheet = false
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.green.opacity(0.1), .white.opacity(0.3)]), startPoint: .top, endPoint: .bottom
                )
                .ignoresSafeArea()
            
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
                    
                    // Star Rating moved here
                    HStack {
                        ForEach(1...5, id: \.self) { star in
                            Image(systemName: star <= book.rating ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                        }
                        Spacer()
                    }
                    .accessibilityLabel("\(book.rating) out of 5 stars")
                    
                    Text(book.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    VStack {
                        Text(book.status.rawValue)
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(8)
                            .background(Color.accentColor.opacity(0.2))
                            .clipShape(Capsule())
                    }
                    
                    Button("Mark as Read") {
                        book.status = .finished
                        print("Button tapped for \(book.title)")
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)
                    
                    Spacer()
                }
                .padding()
            }
        }
        .navigationTitle(book.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") {
                showingEditSheet = true
            }
          }
        }
        .sheet(isPresented: $showingEditSheet) {
            EditView(book: $book)
        }
    }
}
#Preview {
    ContentView()
    
}

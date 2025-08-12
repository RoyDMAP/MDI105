//
//  EditView.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 8/11/25.
//
import SwiftUI

struct EditView: View {
    @Binding var book: Book
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section("Book Details") {
                    TextField("Title", text: $book.title)
                    TextField("Author", text: $book.author)
                    TextField("Description", text: $book.description, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                Section("Rating") {
                    Picker("Rating", selection: $book.rating) {
                        ForEach(1...5, id: \.self) { rating in
                            HStack {
                                Text("\(rating)")
                                ForEach(1...rating, id: \.self) { _ in
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                }
                            }
                            .tag(rating)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section("Status") {
                    Picker("Reading Status", selection: $book.status) {
                        ForEach(BookStatus.allCases, id: \.self) { status in
                            Text(status.rawValue).tag(status)
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
            .navigationTitle("Edit Book")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss ()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

//
//  PostListView.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 9/5/25.
//

import SwiftUI

struct Post: Identifiable, Codable {
    let id = UUID()
    let title: String
    let author: String
    let content: String
    let publishedDate: Date
    let tags: [String]
    var isBookmarked: Bool = false
    var likeCount: Int = 0
    var commentCount: Int = 0
    
    init(title: String, author: String, content: String, publishedDate: Date = Date(), tags: [String] = [], isBookmarked: Bool = false, likeCount: Int = 0, commentCount: Int = 0) {
        self.title = title
        self.author = author
        self.content = content
        self.publishedDate = publishedDate
        self.tags = tags
        self.isBookmarked = isBookmarked
        self.likeCount = likeCount
        self.commentCount = commentCount
    }
}

struct PostListView: View {
    @State private var posts: [Post] = []
    @State private var searchText = ""
    @State private var selectedTag: String?
    @State private var isLoading = false
    @State private var showingAddPost = false
    
    private var filteredPosts: [Post] {
        var result = posts
        
        // Apply search filter
        if !searchText.isEmpty {
            let lowercasedSearch = searchText.lowercased()
            result = result.filter { post in
                post.title.lowercased().contains(lowercasedSearch) ||
                post.author.lowercased().contains(lowercasedSearch) ||
                post.content.lowercased().contains(lowercasedSearch) ||
                post.tags.contains { $0.lowercased().contains(lowercasedSearch) }
            }
        }
        
        // Apply tag filter
        if let selectedTag = selectedTag {
            result = result.filter { $0.tags.contains(selectedTag) }
        }
        
        return result.sorted { $0.publishedDate > $1.publishedDate }
    }
    
    private var allTags: [String] {
        Array(Set(posts.flatMap(\.tags))).sorted()
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                // Tag filter
                if !allTags.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            TagFilterButton(title: "All", isSelected: selectedTag == nil) {
                                selectedTag = nil
                            }
                            
                            ForEach(allTags, id: \.self) { tag in
                                TagFilterButton(title: tag, isSelected: selectedTag == tag) {
                                    selectedTag = selectedTag == tag ? nil : tag
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 8)
                }
                
                // Posts list
                if isLoading {
                    ProgressView("Loading posts...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if filteredPosts.isEmpty {
                    EmptyPostsView(hasSearchText: !searchText.isEmpty)
                } else {
                    List {
                        ForEach(filteredPosts) { post in
                            PostRowView(post: Binding(
                                get: { post },
                                set: { updatedPost in
                                    if let index = posts.firstIndex(where: { $0.id == post.id }) {
                                        posts[index] = updatedPost
                                    }
                                }
                            ))
                        }
                        .onDelete(perform: deletePosts)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Posts")
            .searchable(text: $searchText, prompt: "Search posts...")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddPost = true }) {
                        Image(systemName: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: refreshPosts) {
                        Image(systemName: "arrow.clockwise")
                    }
                    .disabled(isLoading)
                }
            }
            .sheet(isPresented: $showingAddPost) {
                AddPostView(posts: $posts)
            }
            .onAppear {
                if posts.isEmpty {
                    loadPosts()
                }
            }
        }
    }
    
    private func loadPosts() {
        isLoading = true
        
        // Simulate loading delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            posts = getSamplePosts()
            isLoading = false
        }
    }
    
    private func refreshPosts() {
        loadPosts()
    }
    
    private func deletePosts(at offsets: IndexSet) {
        let postsToDelete = offsets.map { filteredPosts[$0] }
        for postToDelete in postsToDelete {
            posts.removeAll { $0.id == postToDelete.id }
        }
    }
}

struct PostRowView: View {
    @Binding var post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(post.title)
                        .font(.headline)
                        .lineLimit(2)
                    
                    Text("by \(post.author)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button(action: { post.isBookmarked.toggle() }) {
                    Image(systemName: post.isBookmarked ? "bookmark.fill" : "bookmark")
                        .foregroundColor(post.isBookmarked ? .blue : .gray)
                }
            }
            
            // Content preview
            Text(post.content)
                .font(.body)
                .lineLimit(3)
                .foregroundColor(.primary)
            
            // Tags
            if !post.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(post.tags, id: \.self) { tag in
                            Text(tag)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(12)
                        }
                    }
                }
            }
            
            // Footer
            HStack {
                Text(post.publishedDate, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                HStack(spacing: 16) {
                    Label("\(post.likeCount)", systemImage: "heart")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Label("\(post.commentCount)", systemImage: "message")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct TagFilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(16)
        }
    }
}

struct EmptyPostsView: View {
    let hasSearchText: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: hasSearchText ? "magnifyingglass" : "doc.text")
                .font(.system(size: 48))
                .foregroundColor(.gray)
            
            Text(hasSearchText ? "No posts found" : "No posts yet")
                .font(.title2)
                .fontWeight(.medium)
            
            Text(hasSearchText ? "Try adjusting your search terms" : "Add your first post to get started")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct AddPostView: View {
    @Binding var posts: [Post]
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var author = ""
    @State private var content = ""
    @State private var tagInput = ""
    @State private var tags: [String] = []
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Post Details") {
                    TextField("Title", text: $title)
                    TextField("Author", text: $author)
                }
                
                Section("Content") {
                    TextField("Write your post...", text: $content, axis: .vertical)
                        .lineLimit(5...10)
                }
                
                Section("Tags") {
                    TextField("Add tags (press return)", text: $tagInput)
                        .onSubmit {
                            addTag()
                        }
                    
                    if !tags.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(tags, id: \.self) { tag in
                                    HStack {
                                        Text(tag)
                                        Button(action: { removeTag(tag) }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.red)
                                        }
                                    }
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(12)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("New Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        savePost()
                    }
                    .disabled(title.isEmpty || author.isEmpty || content.isEmpty)
                }
            }
        }
    }
    
    private func addTag() {
        let trimmedTag = tagInput.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedTag.isEmpty && !tags.contains(trimmedTag) {
            tags.append(trimmedTag)
            tagInput = ""
        }
    }
    
    private func removeTag(_ tag: String) {
        tags.removeAll { $0 == tag }
    }
    
    private func savePost() {
        let newPost = Post(
            title: title,
            author: author,
            content: content,
            publishedDate: Date(),
            tags: tags,
            likeCount: 0,
            commentCount: 0
        )
        
        posts.insert(newPost, at: 0) // Add to beginning for newest first
        dismiss()
    }
}

// MARK: - Sample Data
func getSamplePosts() -> [Post] {
    return [
        Post(
            title: "Getting Started with SwiftUI",
            author: "Jane Developer",
            content: "SwiftUI is Apple's modern framework for building user interfaces across all Apple platforms. In this post, we'll explore the basics of creating your first SwiftUI app and understanding the declarative syntax that makes SwiftUI so powerful.",
            publishedDate: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
            tags: ["SwiftUI", "iOS", "Development"],
            likeCount: 42,
            commentCount: 8
        ),
        Post(
            title: "Advanced iOS Animations",
            author: "Mike Designer",
            content: "Animations breathe life into your apps. Learn how to create smooth, engaging animations that delight users and provide meaningful feedback. We'll cover everything from basic transitions to complex custom animations.",
            publishedDate: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(),
            tags: ["Animation", "iOS", "UX"],
            isBookmarked: true,
            likeCount: 67,
            commentCount: 15
        ),
        Post(
            title: "Building Accessible Apps",
            author: "Sarah Advocate",
            content: "Accessibility isn't just a feature—it's a fundamental part of great app design. Discover how to make your apps usable by everyone, including users with disabilities. Learn about VoiceOver, Dynamic Type, and more.",
            publishedDate: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(),
            tags: ["Accessibility", "Design", "iOS"],
            likeCount: 89,
            commentCount: 23
        ),
        Post(
            title: "State Management Patterns",
            author: "Alex Architect",
            content: "Managing state in complex apps can be challenging. This post explores different state management patterns in SwiftUI, from simple @State to complex architectures using Combine and MVVM.",
            publishedDate: Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date(),
            tags: ["Architecture", "SwiftUI", "State Management"],
            isBookmarked: true,
            likeCount: 156,
            commentCount: 34
        )
    ]
}

#Preview {
    PostListView()
}

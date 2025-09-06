//
//  PostListViewModel.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 9/5/25.
//

import Foundation

protocol PostFetching {
    func fetchPosts() async throws -> [Post]
    func createPost(_ post: Post) async throws -> Post
    func updatePost(_ post: Post) async throws -> Post
    func deletePost(id: UUID) async throws
}

// MARK: - Post API Service
class PostApiService: PostFetching {
    func fetchPosts() async throws -> [Post] {
        try await Task.sleep(for: .seconds(1))
        return getSamplePosts()
    }
    
    func createPost(_ post: Post) async throws -> Post {
        try await Task.sleep(for: .milliseconds(500))
        return post
    }
    
    func updatePost(_ post: Post) async throws -> Post {
        try await Task.sleep(for: .milliseconds(300))
        return post
    }
    
    func deletePost(id: UUID) async throws {
        try await Task.sleep(for: .milliseconds(200))
    }
}

@MainActor // Ensures changes to @Published properties happen on the main thread.
class PostListViewModel: ObservableObject {
    
    @Published var posts: [Post] = []
    @Published var filteredPosts: [Post] = []
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var searchText = "" {
        didSet {
            applyFilters()
        }
    }
    @Published var selectedTag: String? {
        didSet {
            applyFilters()
        }
    }
    
    private let service: PostFetching
    private let postsKey = "SavedPosts"
    
    // Dependency Injection: We can pass in ANY service that conforms to PostFetching.
    // We default to the real one for the live app.
    init(service: PostFetching = PostApiService()) {
        self.service = service
        loadPostsFromStorage()
    }
    
    // MARK: - Computed Properties
    var allTags: [String] {
        Array(Set(posts.flatMap(\.tags))).sorted()
    }
    
    var bookmarkedPosts: [Post] {
        posts.filter(\.isBookmarked)
    }
    
    var searchResultsCount: Int {
        filteredPosts.count
    }
    
    var totalPostsCount: Int {
        posts.count
    }
    
    func loadPosts() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedPosts = try await service.fetchPosts()
            self.posts = mergePosts(fetchedPosts: fetchedPosts, localPosts: self.posts)
            applyFilters()
            savePostsToStorage()
        } catch {
            self.errorMessage = "Failed to fetch posts: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func refreshPosts() async {
        await loadPosts()
    }
    
    func addPost(_ post: Post) async {
        do {
            let createdPost = try await service.createPost(post)
            posts.insert(createdPost, at: 0)
            applyFilters()
            savePostsToStorage()
        } catch {
            errorMessage = "Failed to create post: \(error.localizedDescription)"
        }
    }
    
    func updatePost(_ updatedPost: Post) async {
        do {
            let post = try await service.updatePost(updatedPost)
            
            if let index = posts.firstIndex(where: { $0.id == post.id }) {
                posts[index] = post
                applyFilters()
                savePostsToStorage()
            }
        } catch {
            errorMessage = "Failed to update post: \(error.localizedDescription)"
        }
    }
    
    func deletePost(_ post: Post) async {
        do {
            try await service.deletePost(id: post.id)
            posts.removeAll { $0.id == post.id }
            applyFilters()
            savePostsToStorage()
        } catch {
            errorMessage = "Failed to delete post: \(error.localizedDescription)"
        }
    }
    
    func deletePost(at index: Int) async {
        guard filteredPosts.indices.contains(index) else { return }
        let postToDelete = filteredPosts[index]
        await deletePost(postToDelete)
    }
    
    func toggleBookmark(for postId: UUID) {
        guard let index = posts.firstIndex(where: { $0.id == postId }) else { return }
        posts[index].isBookmarked.toggle()
        applyFilters()
        savePostsToStorage()
    }
    
    func incrementLikes(for postId: UUID) {
        guard let index = posts.firstIndex(where: { $0.id == postId }) else { return }
        posts[index].likeCount += 1
        applyFilters()
        savePostsToStorage()
    }
    
    func selectTag(_ tag: String?) {
        selectedTag = selectedTag == tag ? nil : tag
    }
    
    func clearFilters() {
        searchText = ""
        selectedTag = nil
    }
    
    private func applyFilters() {
        var result = posts
        
        if !searchText.isEmpty {
            let lowercasedSearch = searchText.lowercased()
            result = result.filter { post in
                post.title.lowercased().contains(lowercasedSearch) ||
                post.author.lowercased().contains(lowercasedSearch) ||
                post.content.lowercased().contains(lowercasedSearch) ||
                post.tags.contains { $0.lowercased().contains(lowercasedSearch) }
            }
        }
        
        if let selectedTag = selectedTag {
            result = result.filter { $0.tags.contains(selectedTag) }
        }
        
        filteredPosts = result.sorted { $0.publishedDate > $1.publishedDate }
    }
    
    private func loadPostsFromStorage() {
        guard let data = UserDefaults.standard.data(forKey: postsKey) else { return }
        
        do {
            let decodedPosts = try JSONDecoder().decode([Post].self, from: data)
            posts = decodedPosts
            applyFilters()
        } catch {
            print("Error decoding posts: \(error)")
        }
    }
    
    private func savePostsToStorage() {
        let postsToSave = posts
        
        Task.detached {
            do {
                let encoded = try JSONEncoder().encode(postsToSave)
                UserDefaults.standard.set(encoded, forKey: self.postsKey)
            } catch {
                print("Error encoding posts: \(error)")
            }
        }
    }
    
    private func mergePosts(fetchedPosts: [Post], localPosts: [Post]) -> [Post] {
        let localPostsDict = Dictionary(uniqueKeysWithValues: localPosts.map { ($0.id, $0) })
        let localPostsByTitleAuthor = Dictionary(grouping: localPosts) { "\($0.title)-\($0.author)" }
            .compactMapValues { $0.first }
        
        var mergedPosts: [Post] = []
        var processedIds: Set<UUID> = []
        
        for fetchedPost in fetchedPosts {
            if let existingPost = localPostsDict[fetchedPost.id] ??
               localPostsByTitleAuthor["\(fetchedPost.title)-\(fetchedPost.author)"] {
                
                var mergedPost = fetchedPost
                mergedPost.isBookmarked = existingPost.isBookmarked
                
                mergedPosts.append(mergedPost)
                processedIds.insert(existingPost.id)
            } else {
                mergedPosts.append(fetchedPost)
            }
        }
        
        for localPost in localPosts where !processedIds.contains(localPost.id) {
            mergedPosts.append(localPost)
        }
        
        return mergedPosts
    }
    
    func getPostsByTag(_ tag: String) -> [Post] {
        posts.filter { $0.tags.contains(tag) }
    }
    
    func getPostsByAuthor(_ author: String) -> [Post] {
        posts.filter { $0.author.lowercased() == author.lowercased() }
    }
    
    func getPopularPosts(minimumLikes: Int = 50) -> [Post] {
        posts.filter { $0.likeCount >= minimumLikes }
            .sorted { $0.likeCount > $1.likeCount }
    }
}

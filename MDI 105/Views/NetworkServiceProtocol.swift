//
//  NetworkServiceProtocol.swift
//  MDI 105
//
//  Created by Roy Dimapilis on 9/3/25.
//

import SwiftUI

// MARK: - Network Service Protocol and Implementation
protocol NetworkServiceProtocol {
    func fetchData(url: URL, completion: @escaping (Result<Data, Error>) -> Void)
    func fetchBooks(completion: @escaping (Result<[Book], Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    func fetchData(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
    
    func fetchBooks(completion: @escaping (Result<[Book], Error>) -> Void) {
        // Simulate API delay and return default books
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            completion(.success(getDefaultBooks()))
        }
    }
}

class MockNetworkService: NetworkServiceProtocol {
    var shouldReturnError = false
    var mockBooks: [Book] = []
    var delay: TimeInterval = 0.1
    
    func fetchData(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
            if self.shouldReturnError {
                completion(.failure(NetworkError.requestFailed))
            } else {
                // Simulate successful response
                let data = Data("Mock Data".utf8)
                completion(.success(data))
            }
        }
    }
    
    func fetchBooks(completion: @escaping (Result<[Book], Error>) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
            if self.shouldReturnError {
                completion(.failure(NetworkError.requestFailed))
            } else {
                let books = self.mockBooks.isEmpty ? getDefaultBooks() : self.mockBooks
                completion(.success(books))
            }
        }
    }
    
    // Helper methods for testing
    func setupMockBooks(_ books: [Book]) {
        mockBooks = books
    }
    
    func simulateNetworkError() {
        shouldReturnError = true
    }
    
    func simulateNetworkSuccess() {
        shouldReturnError = false
    }
}

enum NetworkError: Error, LocalizedError {
    case noData
    case requestFailed
    
    var errorDescription: String? {
        switch self {
        case .noData:
            return "No data received"
        case .requestFailed:
            return "Network request failed"
        }
    }
}

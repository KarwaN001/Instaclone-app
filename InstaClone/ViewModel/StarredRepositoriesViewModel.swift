//
//  StarredRepositoriesViewModel.swift
//  InstaClone
//
//  Created by karwan Syborg on 25/08/2025.
//

import SwiftUI


@MainActor
class StarredRepositoriesViewModel: ObservableObject {
    @Published var starredRepositories: [GitHubRepository] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let defaultUsername = "KarwaN001"
    
    func fetchStarredRepositories(for username: String? = nil) {
        let targetUsername = username ?? defaultUsername
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let starred = try await fetchStarredRepos(username: targetUsername)
                self.starredRepositories = starred
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    private func fetchStarredRepos(username: String) async throws -> [GitHubRepository] {
        let url = URL(string: "https://api.github.com/users/\(username)/starred?per_page=50&sort=created")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([GitHubRepository].self, from: data)
    }
}


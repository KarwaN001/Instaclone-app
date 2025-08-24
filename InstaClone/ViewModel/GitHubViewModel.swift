//
//  GitHubViewModel.swift
//  InstaClone
//
//  Created by karwan Syborg on 24/08/2025.
//

import Foundation
import SwiftUI

@MainActor
class GitHubViewModel: ObservableObject {
    @Published var user: GitHubUser?
    @Published var repositories: [GitHubRepository] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let username = "KarwaN001"
    
    func fetchUserData() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                // Fetch user profile
                async let userTask = fetchUser()
                async let reposTask = fetchRepositories()
                
                let (fetchedUser, fetchedRepos) = try await (userTask, reposTask)
                
                self.user = fetchedUser
                self.repositories = fetchedRepos
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    private func fetchUser() async throws -> GitHubUser {
        let url = URL(string: "https://api.github.com/users/\(username)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(GitHubUser.self, from: data)
    }
    
    private func fetchRepositories() async throws -> [GitHubRepository] {
        let url = URL(string: "https://api.github.com/users/\(username)/repos?sort=updated&per_page=30")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([GitHubRepository].self, from: data)
    }
    
    func formattedJoinDate() -> String {
        guard let user = user else { return "" }
        
        let dateFormatter = ISO8601DateFormatter()
        guard let date = dateFormatter.date(from: user.createdAt) else { return "" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return "Joined \(formatter.string(from: date))"
    }
} 
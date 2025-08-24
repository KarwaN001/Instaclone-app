//
//  FollowersViewModel.swift
//  InstaClone
//
//  Created by karwan Syborg on 24/08/2025.
//

import Foundation
import SwiftUI

@MainActor
class FollowersViewModel: ObservableObject {
    @Published var users: [GitHubFollowerUser] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func fetchFollowers(for username: String) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let url = URL(string: "https://api.github.com/users/\(username)/followers")!
                let (data, _) = try await URLSession.shared.data(from: url)
                let followers = try JSONDecoder().decode([GitHubFollowerUser].self, from: data)
                
                self.users = followers
                self.isLoading = false
            } catch {
                self.errorMessage = "Failed to load followers: \(error.localizedDescription)"
                self.isLoading = false
                print("Followers API Error: \(error)")
            }
        }
    }
    
    func fetchFollowing(for username: String) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let url = URL(string: "https://api.github.com/users/\(username)/following")!
                let (data, _) = try await URLSession.shared.data(from: url)
                let following = try JSONDecoder().decode([GitHubFollowerUser].self, from: data)
                
                self.users = following
                self.isLoading = false
            } catch {
                self.errorMessage = "Failed to load following: \(error.localizedDescription)"
                self.isLoading = false
                print("Following API Error: \(error)")
            }
        }
    }
} 
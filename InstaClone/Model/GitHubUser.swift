//
//  GitHubUser.swift
//  InstaClone
//
//  Created by karwan Syborg on 24/08/2025.
//

import Foundation

struct GitHubUser: Codable {
    let login: String
    let id: Int
    let avatarUrl: String
    let name: String?
    let company: String?
    let blog: String?
    let location: String?
    let email: String?
    let bio: String?
    let twitterUsername: String?
    let publicRepos: Int
    let publicGists: Int
    let followers: Int
    let following: Int
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case login, id, name, company, blog, location, email, bio
        case avatarUrl = "avatar_url"
        case twitterUsername = "twitter_username"
        case publicRepos = "public_repos"
        case publicGists = "public_gists"
        case followers, following
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// Simplified model for followers/following lists
struct GitHubFollowerUser: Codable {
    let login: String
    let id: Int
    let avatarUrl: String
    let htmlUrl: String
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case login, id, type
        case avatarUrl = "avatar_url"
        case htmlUrl = "html_url"
    }
}

struct GitHubRepository: Codable {
    let id: Int
    let name: String
    let fullName: String
    let description: String?
    let htmlUrl: String
    let stargazersCount: Int
    let forksCount: Int
    let language: String?
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, language
        case fullName = "full_name"
        case htmlUrl = "html_url"
        case stargazersCount = "stargazers_count"
        case forksCount = "forks_count"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
} 
//
//  GitHubUser.swift
//  InstaClone
//
//  Created by karwan Syborg on 24/08/2025.
//

import SwiftUI

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

// MARK: - GitHub Activity Event Models

struct GitHubActivityEvent: Codable, Identifiable {
    let id: String
    let type: String
    let actor: GitHubEventActor
    let repo: GitHubEventRepo
    let payload: GitHubEventPayload
    let isPublic: Bool
    let createdAt: String
    let org: GitHubEventOrg?
    
    enum CodingKeys: String, CodingKey {
        case id, type, actor, repo, payload, org
        case isPublic = "public"
        case createdAt = "created_at"
    }
}

struct GitHubEventActor: Codable {
    let id: Int
    let login: String
    let displayLogin: String
    let gravatarId: String
    let url: String
    let avatarUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id, login, url
        case displayLogin = "display_login"
        case gravatarId = "gravatar_id"
        case avatarUrl = "avatar_url"
    }
}

struct GitHubEventRepo: Codable {
    let id: Int
    let name: String
    let url: String
}

struct GitHubEventOrg: Codable {
    let id: Int
    let login: String
    let gravatarId: String
    let url: String
    let avatarUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id, login, url
        case gravatarId = "gravatar_id"
        case avatarUrl = "avatar_url"
    }
}

// Generic payload that can handle different event types
struct GitHubEventPayload: Codable {
    // Common fields
    let action: String?
    let ref: String?
    let refType: String?
    let masterBranch: String?
    let description: String?
    let pusherType: String?
    
    // Push event fields
    let pushId: Int?
    let size: Int?
    let distinctSize: Int?
    let head: String?
    let before: String?
    let commits: [GitHubCommit]?
    
    // Release event fields
    let release: GitHubRelease?
    
    // Fork event fields
    let forkee: GitHubRepository?
    
    enum CodingKeys: String, CodingKey {
        case action, ref, description, head, before, commits, release, forkee
        case refType = "ref_type"
        case masterBranch = "master_branch"
        case pusherType = "pusher_type"
        case pushId = "push_id"
        case size
        case distinctSize = "distinct_size"
    }
}

struct GitHubCommit: Codable {
    let sha: String
    let author: GitHubCommitAuthor
    let message: String
    let distinct: Bool
    let url: String
}

struct GitHubCommitAuthor: Codable {
    let email: String
    let name: String
}

struct GitHubRelease: Codable {
    let id: Int
    let tagName: String
    let name: String?
    let body: String?
    let draft: Bool
    let prerelease: Bool
    let createdAt: String
    let publishedAt: String?
    let htmlUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, body, draft, prerelease
        case tagName = "tag_name"
        case createdAt = "created_at"
        case publishedAt = "published_at"
        case htmlUrl = "html_url"
    }
} 

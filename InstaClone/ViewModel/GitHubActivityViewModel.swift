//
//  GitHubActivityViewModel.swift
//  InstaClone
//
//  Created by karwan Syborg on 24/08/2025.
//

import Foundation
import SwiftUI

@MainActor
class GitHubActivityViewModel: ObservableObject {
    @Published var activityEvents: [GitHubActivityEvent] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let defaultUsername = "KarwaN001"
    
    func fetchActivityFeed(for username: String? = nil) {
        let targetUsername = username ?? defaultUsername
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let events = try await fetchReceivedEvents(username: targetUsername)
                self.activityEvents = events
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    func fetchPublicActivity() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let events = try await fetchPublicEvents()
                self.activityEvents = events
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
    
    private func fetchReceivedEvents(username: String) async throws -> [GitHubActivityEvent] {
        let url = URL(string: "https://api.github.com/users/\(username)/received_events?per_page=30")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([GitHubActivityEvent].self, from: data)
    }
    
    private func fetchPublicEvents() async throws -> [GitHubActivityEvent] {
        let url = URL(string: "https://api.github.com/events?per_page=30")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([GitHubActivityEvent].self, from: data)
    }
    
    func refreshActivityFeed() {
        fetchActivityFeed()
    }
    
    func formatTimeAgo(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: dateString) else { return "" }
        
        let now = Date()
        let timeInterval = now.timeIntervalSince(date)
        
        if timeInterval < 60 {
            return "just now"
        } else if timeInterval < 3600 {
            let minutes = Int(timeInterval / 60)
            return "\(minutes)m ago"
        } else if timeInterval < 86400 {
            let hours = Int(timeInterval / 3600)
            return "\(hours)h ago"
        } else {
            let days = Int(timeInterval / 86400)
            return "\(days)d ago"
        }
    }
    
    func eventDescription(for event: GitHubActivityEvent) -> String {
        switch event.type {
        case "PushEvent":
            let commits = event.payload.commits?.count ?? 0
            return "pushed \(commits) commit\(commits == 1 ? "" : "s") to"
        case "WatchEvent":
            return "starred"
        case "ForkEvent":
            return "forked"
        case "CreateEvent":
            if event.payload.refType == "repository" {
                return "created repository"
            } else if event.payload.refType == "branch" {
                return "created branch \(event.payload.ref ?? "") in"
            } else if event.payload.refType == "tag" {
                return "created tag \(event.payload.ref ?? "") in"
            }
            return "created"
        case "ReleaseEvent":
            return "released \(event.payload.release?.tagName ?? "new version") in"
        case "IssuesEvent":
            return "\(event.payload.action ?? "updated") issue in"
        case "PullRequestEvent":
            return "\(event.payload.action ?? "updated") pull request in"
        case "DeleteEvent":
            return "deleted \(event.payload.refType ?? "ref") in"
        default:
            return "updated"
        }
    }
    
    func eventIcon(for eventType: String) -> String {
        switch eventType {
        case "PushEvent":
            return "arrow.up.circle.fill"
        case "WatchEvent":
            return "star.fill"
        case "ForkEvent":
            return "tuningfork"
        case "CreateEvent":
            return "plus.circle.fill"
        case "ReleaseEvent":
            return "tag.fill"
        case "IssuesEvent":
            return "exclamationmark.circle.fill"
        case "PullRequestEvent":
            return "arrow.merge"
        case "DeleteEvent":
            return "trash.fill"
        default:
            return "circle.fill"
        }
    }
    
    func eventColor(for eventType: String) -> Color {
        switch eventType {
        case "PushEvent":
            return .blue
        case "WatchEvent":
            return .yellow
        case "ForkEvent":
            return .green
        case "CreateEvent":
            return .purple
        case "ReleaseEvent":
            return .orange
        case "IssuesEvent":
            return .red
        case "PullRequestEvent":
            return .mint
        case "DeleteEvent":
            return .gray
        default:
            return .primary
        }
    }
} 
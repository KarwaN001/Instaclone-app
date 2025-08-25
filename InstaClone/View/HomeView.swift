//
//  HomeView.swift
//  InstaClone
//
//  Created by karwan Syborg on 24/08/2025.
//

import Foundation
import SwiftUI

struct HomeView: View {
    @StateObject private var activityViewModel = GitHubActivityViewModel()
    @State private var showingPublicFeed = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Top navigation bar
                topNavigationBar
                
                // Feed toggle buttons
                feedToggleButtons
                
                // Activity feed
                activityFeedContent
            }
            .navigationBarHidden(true)
            .onAppear {
                activityViewModel.fetchActivityFeed()
            }
        }
    }
    
    private var topNavigationBar: some View {
        HStack {
            Text("GitGram")
                .font(.custom("Billabong", size: 35, relativeTo: .largeTitle))
                .foregroundColor(.primary)
            
            Spacer()
            
            HStack(spacing: 15) {
                Button(action: {
                    activityViewModel.refreshActivityFeed()
                }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                
                Button(action: {
                    // Handle notifications
                }) {
                    Image(systemName: "heart")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                
                Button(action: {
                    // Handle messages
                }) {
                    Image(systemName: "paperplane")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .background(Color(UIColor.systemBackground))
    }
    
    private var feedToggleButtons: some View {
        HStack(spacing: 0) {
            Button(action: {
                showingPublicFeed = false
                activityViewModel.fetchActivityFeed()
            }) {
                VStack(spacing: 8) {
                    Text("Following")
                        .font(.system(size: 16, weight: showingPublicFeed ? .regular : .semibold))
                        .foregroundColor(showingPublicFeed ? .gray : .primary)
                    
                    Rectangle()
                        .fill(showingPublicFeed ? Color.clear : Color.primary)
                        .frame(height: 1)
                }
            }
            
            Button(action: {
                showingPublicFeed = true
                activityViewModel.fetchPublicActivity()
            }) {
                VStack(spacing: 8) {
                    Text("Discover")
                        .font(.system(size: 16, weight: showingPublicFeed ? .semibold : .regular))
                        .foregroundColor(showingPublicFeed ? .primary : .gray)
                    
                    Rectangle()
                        .fill(showingPublicFeed ? Color.primary : Color.clear)
                        .frame(height: 1)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(UIColor.systemBackground))
    }
    
    private var activityFeedContent: some View {
        Group {
            if activityViewModel.isLoading {
                loadingView
            } else if let errorMessage = activityViewModel.errorMessage {
                errorView(errorMessage)
            } else if activityViewModel.activityEvents.isEmpty {
                emptyStateView
            } else {
                activityFeedList
            }
        }
    }
    
    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
                .scaleEffect(1.2)
            Text("Loading activity...")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.top, 8)
            Spacer()
        }
    }
    
    private func errorView(_ message: String) -> some View {
        VStack {
            Spacer()
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.red)
            Text("Error loading feed")
                .font(.headline)
                .padding(.top, 8)
            Text(message)
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Button("Try Again") {
                if showingPublicFeed {
                    activityViewModel.fetchPublicActivity()
                } else {
                    activityViewModel.fetchActivityFeed()
                }
            }
            .padding(.top, 16)
            Spacer()
        }
    }
    
    private var emptyStateView: some View {
        VStack {
            Spacer()
            Image(systemName: "person.2")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            Text("No Activity Yet")
                .font(.headline)
                .padding(.top, 8)
            Text(showingPublicFeed ? "No public activity found" : "Follow some developers to see their activity here!")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Spacer()
        }
    }
    
    private var activityFeedList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(activityViewModel.activityEvents) { event in
                    ActivityEventCard(event: event, viewModel: activityViewModel)
                    
                    // Separator between posts
                    Rectangle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(height: 8)
                }
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
        .refreshable {
            if showingPublicFeed {
                activityViewModel.fetchPublicActivity()
            } else {
                activityViewModel.fetchActivityFeed()
            }
        }
    }
}

struct ActivityEventCard: View {
    let event: GitHubActivityEvent
    let viewModel: GitHubActivityViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // HEADER SECTION
            VStack(spacing: 0) {
                HStack(spacing: 12) {
                    // User avatar with border
                    AsyncImage(url: URL(string: event.actor.avatarUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                    }
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        // Username
                        Text(event.actor.login)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.primary)
                        
                        // Activity description
                        HStack(spacing: 4) {
                            Text(viewModel.eventDescription(for: event))
                                .font(.system(size: 14))
                                .foregroundColor(.secondary)
                            
                            Text(repositoryName)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.blue)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(4)
                        }
                        
                        // Timestamp
                        Text(viewModel.formatTimeAgo(event.createdAt))
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    // Event type badge
                    VStack(spacing: 4) {
                        Image(systemName: viewModel.eventIcon(for: event.type))
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 36, height: 36)
                            .background(viewModel.eventColor(for: event.type))
                            .clipShape(Circle())
                        
                        Text(eventTypeShort)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                
                // Divider
                Rectangle()
                    .fill(Color.gray.opacity(0.15))
                    .frame(height: 1)
            }
            
            // CONTENT SECTION
            if let contentInfo = eventContentInfo {
                VStack(spacing: 0) {
                    // Main content area
                    VStack(alignment: .leading, spacing: 12) {
                        // Title section
                        VStack(alignment: .leading, spacing: 6) {
                            Text(contentInfo.title)
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.primary)
                                .lineLimit(2)
                            
                            if !contentInfo.description.isEmpty {
                                Text(contentInfo.description)
                                    .font(.system(size: 15))
                                    .foregroundColor(.secondary)
                                    .lineLimit(4)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        
                        // Visual representation area
                        HStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(stops: [
                                            .init(color: viewModel.eventColor(for: event.type).opacity(0.2), location: 0.0),
                                            .init(color: viewModel.eventColor(for: event.type).opacity(0.1), location: 0.5),
                                            .init(color: viewModel.eventColor(for: event.type).opacity(0.05), location: 1.0)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(height: 80)
                                .overlay(
                                    HStack(spacing: 12) {
                                        Image(systemName: viewModel.eventIcon(for: event.type))
                                            .font(.system(size: 24, weight: .medium))
                                            .foregroundColor(viewModel.eventColor(for: event.type))
                                        
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(event.type.replacingOccurrences(of: "Event", with: ""))
                                                .font(.system(size: 15, weight: .semibold))
                                                .foregroundColor(.primary)
                                            
                                            Text(event.repo.name)
                                                .font(.system(size: 13))
                                                .foregroundColor(.secondary)
                                                .lineLimit(1)
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.horizontal, 16)
                                )
                        }
                        
                        // Metadata section
                        if !contentInfo.metadata.isEmpty {
                            HStack {
                                Text(contentInfo.metadata)
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.blue)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(6)
                                
                                Spacer()
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
            }
        }
        .background(Color(UIColor.systemBackground))
        .overlay(
            RoundedRectangle(cornerRadius: 0)
                .stroke(Color.gray.opacity(0.1), lineWidth: 0.5)
        )
    }
    
    private var eventTypeShort: String {
        switch event.type {
        case "PushEvent": return "PUSH"
        case "WatchEvent": return "STAR"
        case "ForkEvent": return "FORK"
        case "CreateEvent": return "NEW"
        case "ReleaseEvent": return "RELEASE"
        case "IssuesEvent": return "ISSUE"
        case "PullRequestEvent": return "PR"
        case "DeleteEvent": return "DELETE"
        default: return "ACTIVITY"
        }
    }
    
    private var repositoryName: String {
        return event.repo.name.components(separatedBy: "/").last ?? event.repo.name
    }
    
    private var eventContentInfo: EventContentInfo? {
        switch event.type {
        case "PushEvent":
            if let commits = event.payload.commits {
                let commitCount = commits.count
                let firstCommit = commits.first
                return EventContentInfo(
                    title: "\(commitCount) commit\(commitCount == 1 ? "" : "s") pushed",
                    description: firstCommit?.message ?? "",
                    metadata: "to \(event.repo.name)"
                )
            }
        case "WatchEvent":
            return EventContentInfo(
                title: "Repository starred",
                description: "Added \(repositoryName) to starred repositories",
                metadata: "⭐ Star event"
            )
        case "ForkEvent":
            return EventContentInfo(
                title: "Repository forked",
                description: "Created a fork of \(repositoryName)",
                metadata: "🍴 Fork event"
            )
        case "ReleaseEvent":
            if let release = event.payload.release {
                return EventContentInfo(
                    title: "New release: \(release.tagName)",
                    description: release.name ?? release.body ?? "New version released",
                    metadata: "📦 Release"
                )
            }
        case "CreateEvent":
            let refType = event.payload.refType ?? "repository"
            return EventContentInfo(
                title: "\(refType.capitalized) created",
                description: event.payload.description ?? "New \(refType) created",
                metadata: "✨ \(refType.capitalized)"
            )
        case "IssuesEvent":
            let action = event.payload.action ?? "updated"
            return EventContentInfo(
                title: "Issue \(action)",
                description: "Issue in \(repositoryName)",
                metadata: "🐛 Issue"
            )
        case "PullRequestEvent":
            let action = event.payload.action ?? "updated"
            return EventContentInfo(
                title: "Pull request \(action)",
                description: "Pull request in \(repositoryName)",
                metadata: "🔄 Pull Request"
            )
        default:
            return EventContentInfo(
                title: event.type.replacingOccurrences(of: "Event", with: ""),
                description: "Activity in \(repositoryName)",
                metadata: "📝 Activity"
            )
        }
        return nil
    }
}

struct EventContentInfo {
    let title: String
    let description: String
    let metadata: String
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

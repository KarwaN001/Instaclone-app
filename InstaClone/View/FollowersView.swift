//
//  FollowersView.swift
//  InstaClone
//
//  Created by karwan Syborg on 24/08/2025.
//

import SwiftUI

enum FollowType {
    case followers
    case following
}

struct FollowersView: View {
    let followType: FollowType
    let username: String
    @StateObject private var viewModel = FollowersViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var title: String {
        switch followType {
        case .followers:
            return "Followers"
        case .following:
            return "Following"
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading \(title.lowercased())...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let errorMessage = viewModel.errorMessage {
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        Text("Error loading \(title.lowercased())")
                            .font(.headline)
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Button("Retry") {
                            loadData()
                        }
                        .padding(.top)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if viewModel.users.isEmpty {
                    VStack {
                        Image(systemName: followType == .followers ? "person.2" : "person.3")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                        Text("No \(title.lowercased()) yet")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        ForEach(viewModel.users, id: \.id) { user in
                            FollowerRowView(user: user)
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .onAppear {
            loadData()
        }
    }
    
    private func loadData() {
        switch followType {
        case .followers:
            viewModel.fetchFollowers(for: username)
        case .following:
            viewModel.fetchFollowing(for: username)
        }
    }
}

struct FollowerRowView: View {
    let user: GitHubFollowerUser
    @State private var showingProfile = false
    
    var body: some View {
        HStack(spacing: 12) {
            // Avatar
            AsyncImage(url: URL(string: user.avatarUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Circle()
                    .fill(Color(.systemGray5))
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundColor(.secondary)
                    )
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())
            
            // User info
            VStack(alignment: .leading, spacing: 4) {
                Text(user.login)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(user.type)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            // View button
            Button(action: {
                showingProfile = true
            }) {
                Text("View")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.blue)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.blue, lineWidth: 1)
                    )
            }
        }
        .padding(.vertical, 4)
        .background(Color(.systemBackground))
        .onTapGesture {
            showingProfile = true
        }
        .sheet(isPresented: $showingProfile) {
            if let url = URL(string: "https://github.com/\(user.login)") {
                RepositoryWebView(url: url, repositoryName: user.login)
            }
        }
    }
}

struct FollowersView_Previews: PreviewProvider {
    static var previews: some View {
        FollowersView(followType: .followers, username: "KarwaN001")
    }
}

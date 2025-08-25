//
//  StarView.swift
//  InstaClone
//
//  Created by karwan Syborg on 25/08/2025.
//

import SwiftUI

struct StarView: View {
    @StateObject private var viewModel = StarredRepositoriesViewModel()
    @State private var showingWebView = false
    @State private var selectedRepository: GitHubRepository?
    
    var body: some View {
        NavigationView {
            if viewModel.isLoading {
                VStack {
                    ProgressView()
                        .scaleEffect(1.2)
                    Text("Loading starred repositories...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.top, 8)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage = viewModel.errorMessage {
                VStack(spacing: 16) {
                    Image(systemName: "star.slash")
                        .font(.system(size: 50))
                        .foregroundColor(.orange)
                    
                    Text("Unable to load starred repositories")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button("Retry") {
                        viewModel.fetchStarredRepositories()
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.starredRepositories.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "star")
                        .font(.system(size: 50))
                        .foregroundColor(.yellow)
                    
                    Text("No starred repositories")
                        .font(.headline)
                    
                    Text("Repositories you star will appear here")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        // Header Section
                        headerSection
                        
                        // Stats Section
                        statsSection
                        
                        // Starred Repositories Grid
                        repositoriesGrid
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.title3)
                    Text("Starred")
                        .font(.title2)
                        .fontWeight(.bold)
                }
            }
        }
        .onAppear {
            if viewModel.starredRepositories.isEmpty {
                viewModel.fetchStarredRepositories()
            }
        }
        .sheet(isPresented: $showingWebView) {
            if let repository = selectedRepository,
               let url = URL(string: repository.htmlUrl) {
                RepositoryWebView(url: url, repositoryName: repository.name)
            }
        }
        .refreshable {
            viewModel.fetchStarredRepositories()
        }
    }
    
    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 12) {
            // Instagram-style gradient circle with star icon
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.pink, .purple, .orange, .yellow],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 90, height: 90)
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 4)
                        .shadow(color: Color.black.opacity(0.1), radius: 4)
                )
                .overlay(
                    Image(systemName: "star.fill")
                        .font(.system(size: 35, weight: .bold))
                        .foregroundColor(.white)
                )
            
            Text("Your Starred Repositories")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Discover and revisit your favorite GitHub projects")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding(.top, 20)
        .padding(.bottom, 24)
    }
    
    // MARK: - Stats Section
    private var statsSection: some View {
        HStack(spacing: 0) {
            // Total Stars
            VStack(spacing: 4) {
                Text("\(viewModel.starredRepositories.count)")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.primary)
                Text("Starred")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            
            // Total Stars Count (sum of all stargazers)
            VStack(spacing: 4) {
                Text("\(formatCount(totalStarsCount))")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.primary)
                Text("Total ⭐")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            
            // Languages Count
            VStack(spacing: 4) {
                Text("\(uniqueLanguagesCount)")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.primary)
                Text("Languages")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal)
        .padding(.bottom, 24)
    }
    
    // MARK: - Repositories Grid
    private var repositoriesGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
            ForEach(viewModel.starredRepositories, id: \.id) { repo in
                repositoryCard(repo)
            }
        }
        .padding(.horizontal, 16)
    }
    
    // MARK: - Repository Card
    private func repositoryCard(_ repo: GitHubRepository) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header with icon and star status
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 10) {
                    // Language icon with gradient
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            LinearGradient(
                                colors: LanguageHelper.gradientColorsForLanguage(repo.language ?? "").map { $0.opacity(0.2) },
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: LanguageHelper.iconForLanguage(repo.language ?? ""))
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(LanguageHelper.gradientColorsForLanguage(repo.language ?? "").first ?? .gray)
                        )
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(repo.name)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.primary)
                            .lineLimit(1)
                        
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 8))
                                .foregroundColor(.yellow)
                            Text("Starred")
                                .font(.system(size: 9, weight: .medium))
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                }
                
                // Description
                Text(repo.description ?? "No description available")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .frame(minHeight: 44) // Consistent height
            }
            .padding(.top, 16)
            .padding(.horizontal, 16)
            
            Spacer()
            
            // Bottom section with language and stats
            VStack(spacing: 8) {
                Divider()
                    .opacity(0.3)
                
                HStack {
                    // Language indicator
                    if let language = repo.language {
                        HStack(spacing: 5) {
                            Circle()
                                .fill(LanguageHelper.gradientColorsForLanguage(language).first ?? .gray)
                                .frame(width: 8, height: 8)
                            Text(language)
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.primary)
                        }
                    }
                    
                    Spacer()
                    
                    // Stats
                    HStack(spacing: 8) {
                        if repo.stargazersCount > 0 {
                            HStack(spacing: 2) {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 9))
                                    .foregroundColor(.yellow)
                                Text("\(formatCount(repo.stargazersCount))")
                                    .font(.system(size: 9, weight: .semibold))
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        if repo.forksCount > 0 {
                            HStack(spacing: 2) {
                                Image(systemName: "tuningfork")
                                    .font(.system(size: 9))
                                    .foregroundColor(.blue)
                                Text("\(formatCount(repo.forksCount))")
                                    .font(.system(size: 9, weight: .semibold))
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 14)
            }
        }
        .frame(height: 140)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(.systemGray6), lineWidth: 0.5)
                )
        )
        .contentShape(RoundedRectangle(cornerRadius: 16))
        .onTapGesture {
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
            
            selectedRepository = repo
            showingWebView = true
        }
    }
    
    // MARK: - Computed Properties
    private var totalStarsCount: Int {
        viewModel.starredRepositories.reduce(0) { $0 + $1.stargazersCount }
    }
    
    private var uniqueLanguagesCount: Int {
        Set(viewModel.starredRepositories.compactMap { $0.language }).count
    }
    
    // MARK: - Helper Functions
    private func formatCount(_ count: Int) -> String {
        if count >= 1000000 {
            return String(format: "%.1fM", Double(count) / 1000000.0)
        } else if count >= 1000 {
            return String(format: "%.1fK", Double(count) / 1000.0)
        }
        return "\(count)"
    }
}

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

struct StarView_Previews: PreviewProvider {
    static var previews: some View {
        StarView()
    }
}



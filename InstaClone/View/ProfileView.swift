//
//  ProfileView.swift
//  InstaClone
//
//  Created by karwan Syborg on 24/08/2025.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = GitHubViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            if viewModel.isLoading {
                ProgressView("Loading GitHub Profile...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let errorMessage = viewModel.errorMessage {
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                    Text("Error loading profile")
                        .font(.headline)
                    Text(errorMessage)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Button("Retry") {
                        viewModel.fetchUserData()
                    }
                    .padding(.top)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    VStack(spacing: 5) {
                        // Profile Header
                        profileHeader
                        
                        // Bio Section
                        bioSection
                        
                        // Action Buttons
                        actionButtons
                        
                        // Repository Highlights (instead of story highlights)
                        repositoryHighlights
                        
                        // Tab Selection
                        tabSelection
                        
                        // Repository Grid (instead of posts)
                        repositoryGrid
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        HStack {
                            Text(viewModel.user?.login ?? "")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Image(systemName: "chevron.down")
                                .font(.caption)
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack(spacing: 15) {
                            Button(action: {}) {
                                Image(systemName: "plus.app")
                                    .font(.title2)
                            }
                            Button(action: {}) {
                                Image(systemName: "line.3.horizontal")
                                    .font(.title2)
                            }
                        }
                        .foregroundColor(.black)
                    }
                }
            }
        }
        .onAppear {
            if viewModel.user == nil {
                viewModel.fetchUserData()
            }
        }
    }
    
    // MARK: - Profile Header
    private var profileHeader: some View {
        HStack {
            // Profile Picture with real GitHub avatar
            AsyncImage(url: URL(string: viewModel.user?.avatarUrl ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Circle()
                    .fill(Color(.systemGray5))
                    .overlay(
                        Image(systemName: "person.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.secondary)
                    )
            }
            .frame(width: 80, height: 80)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [.pink, .purple, .orange],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 3
                    )
            )
            
            Spacer()
            
            // Real GitHub Stats
            HStack(spacing: 30) {
                VStack {
                    Text("\(viewModel.repositories.count)")
                        .font(.headline)
                        .fontWeight(.semibold)
                    Text("Repos")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack {
                    Text("\(viewModel.user?.followers ?? 0)")
                        .font(.headline)
                        .fontWeight(.semibold)
                    Text("Followers")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack {
                    Text("\(viewModel.user?.following ?? 0)")
                        .font(.headline)
                        .fontWeight(.semibold)
                    Text("Following")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
    
    // MARK: - Bio Section with real GitHub data
    private var bioSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    if let name = viewModel.user?.name {
                        Text(name)
                            .font(.footnote)
                            .fontWeight(.semibold)
                    }
                    
                    if let bio = viewModel.user?.bio {
                        Text(bio)
                            .font(.footnote)
                    }
                    
                    if let company = viewModel.user?.company {
                        Text("🏢 \(company)")
                            .font(.footnote)
                    }
                    
                    if let location = viewModel.user?.location {
                        Text("📍 \(location)")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    
                    if let blog = viewModel.user?.blog, !blog.isEmpty {
                        Text(blog)
                            .font(.footnote)
                            .foregroundColor(.blue)
                    }
                    
                    Text(viewModel.formattedJoinDate())
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
    }
    
    // MARK: - Action Buttons
    private var actionButtons: some View {
        HStack(spacing: 8) {
            Button(action: {}) {
                Text("View on GitHub")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 32)
                    .background(Color(.systemGray6))
                    .cornerRadius(6)
            }
            .foregroundColor(.black)
            
            Button(action: {}) {
                Text("Share profile")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .frame(height: 32)
                    .background(Color(.systemGray6))
                    .cornerRadius(6)
            }
            .foregroundColor(.black)
            
            Button(action: {}) {
                Image(systemName: "star")
                    .font(.footnote)
                    .frame(width: 32, height: 32)
                    .background(Color(.systemGray6))
                    .cornerRadius(6)
            }
            .foregroundColor(.black)
        }
        .padding(.horizontal)
        .padding(.top, 12)
    }
    
    // MARK: - Repository Highlights (instead of story highlights)
    private var repositoryHighlights: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                // Show top repositories as highlights
                ForEach(Array(viewModel.repositories.prefix(6)), id: \.id) { repo in
                    VStack(spacing: 8) {
                        // Modern circular highlight with language-based gradient
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: gradientColorsForLanguage(repo.language ?? ""),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 68, height: 68)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 3)
                                    .shadow(color: Color.black.opacity(0.1), radius: 2)
                            )
                            .overlay(
                                // Dynamic icon based on language or repository type
                                VStack(spacing: 2) {
                                    Image(systemName: iconForLanguage(repo.language ?? ""))
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.white)
                                    
                                    if repo.stargazersCount > 0 {
                                        HStack(spacing: 1) {
                                            Image(systemName: "star.fill")
                                                .font(.system(size: 6))
                                                .foregroundColor(.white.opacity(0.9))
                                            Text("\(formatCount(repo.stargazersCount))")
                                                .font(.system(size: 6, weight: .bold))
                                                .foregroundColor(.white.opacity(0.9))
                                        }
                                    }
                                }
                            )
                            .scaleEffect(1.0)
                        
                        // Repository name
                        Text(String(repo.name.prefix(10)))
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.primary)
                            .lineLimit(1)
                            .multilineTextAlignment(.center)
                    }
                    .onTapGesture {
                        // Add haptic feedback and open repository
                        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                        impactFeedback.impactOccurred()
                        
                        if let url = URL(string: repo.htmlUrl) {
                            UIApplication.shared.open(url)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.top, 16)
    }
    
    // Helper function for language-based gradients
    private func gradientColorsForLanguage(_ language: String) -> [Color] {
        switch language.lowercased() {
        case "swift": return [.orange, .red]
        case "javascript": return [.yellow, .orange]
        case "python": return [.blue, .cyan]
        case "java": return [.red, .orange]
        case "typescript": return [.blue, .purple]
        case "html": return [.orange, .pink]
        case "css": return [.blue, .green]
        case "dart": return [.blue, .teal]
        case "kotlin": return [.purple, .pink]
        case "go": return [.cyan, .blue]
        case "rust": return [.orange, .brown]
        case "c++", "cpp": return [.blue, .purple]
        case "c": return [.gray, .blue]
        case "php": return [.purple, .blue]
        case "Blade": return [.red, .orange]
        case "ruby": return [.red, .pink]
        default: return [.gray, .secondary]
        }
    }
    
    // Helper function for language-based icons
    private func iconForLanguage(_ language: String) -> String {
        switch language.lowercased() {
        case "swift": return "swift"
        case "javascript": return "curlybraces"
        case "python": return "terminal"
        case "java": return "cup.and.saucer"
        case "typescript": return "t.square"
        case "html": return "globe"
        case "css": return "paintbrush"
        case "dart": return "target"
        case "kotlin": return "k.square"
        case "go": return "goforward"
        case "rust": return "gear"
        case "c++", "cpp": return "plus.forwardslash.minus"
        case "c": return "c.square"
        case "php": return "p.square"
        case "Blade": return "crown"
        case "ruby": return "diamond"
        default: return "code"
        }
    }
    
    // MARK: - Tab Selection
    private var tabSelection: some View {
        HStack {
            Button(action: { selectedTab = 0 }) {
                Image(systemName: "folder")
                    .font(.title3)
                    .foregroundColor(selectedTab == 0 ? .black : .gray)
            }
            .frame(maxWidth: .infinity)
            
            Button(action: { selectedTab = 1 }) {
                Image(systemName: "star")
                    .font(.title3)
                    .foregroundColor(selectedTab == 1 ? .black : .gray)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.top, 16)
        .padding(.bottom, 5)
        .overlay(
            Rectangle()
                .fill(Color.black)
                .frame(height: 1)
                .offset(x: selectedTab == 0 ? -UIScreen.main.bounds.width/2 : UIScreen.main.bounds.width/2, y: 20)
                .animation(.easeInOut(duration: 0.2), value: selectedTab)
        )
    }
    
    // MARK: - Repository Grid (instead of posts grid)
    private var repositoryGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 2), spacing: 10) {
            ForEach(viewModel.repositories, id: \.id) { repo in
                VStack(alignment: .leading, spacing: 0) {
                    // Header section
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 10) {
                            // Language-specific icon with gradient background
                            RoundedRectangle(cornerRadius: 8)
                                .fill(
                                    LinearGradient(
                                        colors: gradientColorsForLanguage(repo.language ?? "").map { $0.opacity(0.2) },
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 36, height: 36)
                                .overlay(
                                    Image(systemName: iconForLanguage(repo.language ?? ""))
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(gradientColorsForLanguage(repo.language ?? "").first ?? .gray)
                                )
                            
                            VStack(alignment: .leading, spacing: 1) {
                                Text(repo.name)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.primary)
                                    .lineLimit(1)
                                
                                HStack(spacing: 4) {
                                    Image(systemName: "globe")
                                        .font(.system(size: 8))
                                        .foregroundColor(.green)
                                    Text("Public")
                                        .font(.system(size: 9, weight: .medium))
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            Spacer(minLength: 0)
                        }
                        
                        // Description
                        Text(repo.description ?? "")
                            .font(.system(size: 11, weight: .regular))
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(height: 32) // Fixed height for consistency
                    }
                    .padding(.top, 14)
                    .padding(.horizontal, 14)
                    
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
                                    .fill(gradientColorsForLanguage(language).first ?? .gray)
                                    .frame(width: 8, height: 8)
                                    Text(language)
                                        .font(.system(size: 10, weight: .medium))
                                        .foregroundColor(.primary)
                                }
                            }
                            
                            Spacer()
                            
                            // Stats
                            HStack(spacing: 10) {
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
                        .padding(.horizontal, 14)
                        .padding(.bottom, 12)
                    }
                }
                .frame(height: 130) // Fixed height for uniformity
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
                .scaleEffect(1.0)
                .onTapGesture {
                    // Handle repository tap with haptic feedback
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
                    
                    // Add subtle bounce animation
                    withAnimation(.easeInOut(duration: 0.1)) {
                        // Animation handled by the system
                    }
                    
                    if let url = URL(string: repo.htmlUrl) {
                        UIApplication.shared.open(url)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
    
    // Helper function to format large numbers
    private func formatCount(_ count: Int) -> String {
        if count >= 1000 {
            return String(format: "%.1fk", Double(count) / 1000.0)
        }
        return "\(count)"
    }
    

}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

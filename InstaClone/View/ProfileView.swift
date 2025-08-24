//
//  ProfileView.swift
//  InstaClone
//
//  Created by karwan Syborg on 24/08/2025.
//

import SwiftUI

struct ProfileView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 5) {
                    // Profile Header
                    profileHeader
                    
                    // Bio Section
                    bioSection
                    
                    // Action Buttons
                    actionButtons
                    
                    // Story Highlights
                    storyHighlights
                    
                    // Tab Selection
                    tabSelection
                    
                    // Posts Grid
                    postsGrid
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Text("karwan.syborg")
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
    
    // MARK: - Profile Header
    private var profileHeader: some View {
        HStack {
            // Profile Picture
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.pink, .purple, .orange],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 86, height: 86)
                .overlay(
                    Circle()
                        .fill(Color.white)
                        .frame(width: 80, height: 80)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                        )
                )
            
            Spacer()
            
            // Stats
            HStack(spacing: 30) {
                VStack {
                    Text("127")
                        .font(.headline)
                        .fontWeight(.semibold)
                    Text("Posts")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack {
                    Text("2,456")
                        .font(.headline)
                        .fontWeight(.semibold)
                    Text("Followers")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack {
                    Text("1,234")
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
    
    // MARK: - Bio Section
    private var bioSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Karwan Syborg")
                        .font(.footnote)
                        .fontWeight(.semibold)
                    
                    Text("iOS Developer 📱")
                        .font(.footnote)
                    
                    Text("Building amazing apps with SwiftUI")
                        .font(.footnote)
                    
                    Text("📍 Kurdistan, Iraq")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    
                    Text("linktr.ee/karwansyborg")
                        .font(.footnote)
                        .foregroundColor(.blue)
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
                Text("Edit profile")
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
                Image(systemName: "person.badge.plus")
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
    
    // MARK: - Story Highlights
    private var storyHighlights: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                // New highlight
                VStack {
                    Circle()
                        .stroke(Color(.systemGray4), lineWidth: 1)
                        .frame(width: 64, height: 64)
                        .overlay(
                            Image(systemName: "plus")
                                .font(.title2)
                                .foregroundColor(.secondary)
                        )
                    Text("New")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Sample highlights
                ForEach(["Travel", "Food", "Work", "Nature"], id: \.self) { highlight in
                    VStack {
                        Circle()
                            .fill(Color(.systemGray5))
                            .frame(width: 64, height: 64)
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.title2)
                                    .foregroundColor(.secondary)
                            )
                        Text(highlight)
                            .font(.caption)
                            .foregroundColor(.primary)
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.top, 16)
    }
    
    // MARK: - Tab Selection
    private var tabSelection: some View {
        HStack {
            Button(action: { selectedTab = 0 }) {
                Image(systemName: "grid")
                    .font(.title3)
                    .foregroundColor(selectedTab == 0 ? .black : .gray)
            }
            .frame(maxWidth: .infinity)
            
            Button(action: { selectedTab = 1 }) {
                Image(systemName: "person.crop.square")
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
    
    // MARK: - Posts Grid
    private var postsGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 1), count: 3), spacing: 1) {
            ForEach(0..<21, id: \.self) { index in
                Rectangle()
                    .fill(Color(.systemGray5))
                    .aspectRatio(1, contentMode: .fit)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.title)
                            .foregroundColor(.secondary)
                    )
                    .onTapGesture {
                        // Handle post tap
                    }
            }
        }
        .padding(.top, 1)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

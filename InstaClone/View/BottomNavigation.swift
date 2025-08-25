//
//  BottomNavigation.swift
//  InstaClone
//
//  Created by karwan Syborg on 24/08/2025.
//

import SwiftUI

struct BottomNavigation: View {
    
    init() {
        // Configure tab bar appearance to ensure solid background
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    var body: some View {
        TabView {
            // Home Tab
            HomeView()
            .tabItem {
                Image(systemName: "house")
            }
            
//            // Search Tab
//            VStack {
//                Text("Search Screen")
//                    .font(.title)
//                    .foregroundColor(.primary)
//            }
//            .tabItem {
//                Image(systemName: "magnifyingglass")
//            }
//
//            // Add Post Tab
//            VStack {
//                Text("Add Post Screen")
//                    .font(.title)
//                    .foregroundColor(.primary)
//            }
//            .tabItem {
//                Image(systemName: "plus.square")
//            }
            
            // Star Tab
            StarView()
            .tabItem {
                Image(systemName: "star")
            }
            
            // Profile Tab
            ProfileView()
            .tabItem {
                Image(systemName: "person.circle")
            }
        }
        .accentColor(.black)
        .background(Color(UIColor.systemBackground))
    }
}

struct BottomNavigation_Previews: PreviewProvider {
    static var previews: some View {
        BottomNavigation()
    }
} 

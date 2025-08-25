//
//  BottomNavigation.swift
//  InstaClone
//
//  Created by karwan Syborg on 24/08/2025.
//

import SwiftUI

struct BottomNavigation: View {
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
            
            // star Tab
            VStack {
                Text("Notifications Screen")
                    .font(.title)
                    .foregroundColor(.primary)
            }
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
    }
}

struct BottomNavigation_Previews: PreviewProvider {
    static var previews: some View {
        BottomNavigation()
    }
} 

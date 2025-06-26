//
//  MainView.swift
//  manifest
//
//  Created by Ferhat Okan İdem on 6.06.2025.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            ManifestView()
                .tabItem {
                    Label("Wish Bubble", systemImage: "wand.and.stars")
                }
            
            SocialFeedView()
                .tabItem {
                    Label("Community", systemImage: "bubble.left.and.bubble.right.fill")
                }
            
            SpecialDaysView()
                .tabItem {
                    Label("Özel Günler", systemImage: "calendar")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
} 
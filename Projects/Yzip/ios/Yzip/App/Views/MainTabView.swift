//
// HomeTabView.swift
// Yzip
//
// Created 4/3/25
// Copyright © 2025 Yzip. All rights reserved.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("홈", systemImage: "house")
                }

            TransitView()
                .tabItem {
                    Label("교통", systemImage: "bus")
                }

            NoticeView()
                .tabItem {
                    Label("공지", systemImage: "info.bubble.fill")
                }

            MyInfoView()
                .tabItem {
                    Label("학생증", systemImage: "person.text.rectangle")
                }

            LibraryView()
                .tabItem {
                    Label("도서관", systemImage: "book")
                }
        }
    }
}

#Preview {
    MainTabView()
}

//
// HomeView.swift
// Yzip
//
// Created 4/3/25
// Copyright © 2025 Yzip. All rights reserved.
//

import SwiftUI
import UIKit

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    GreetingSection()
                    IDAndLibrarySection()
                    NoticePreviewSection()
                    QuickMenuSection()
                    
                    Spacer(minLength: 40)
                }
                .padding(.horizontal)
            }
            .background(Color(UIColor.systemGroupedBackground))
            .navigationTitle("Y.zip")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button { /* 검색 */ } label: {
                        Image(systemName: "magnifyingglass")
                    }
                    
                    NavigationLink(destination: SettingView()) {
                        Image(systemName: "gearshape")
                    }
                }
            }
        }
    }
}

// MARK: - 인사말 + 날짜

private struct GreetingSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("안녕하세요, 곤지님 👋")
                .font(.title2)
                .bold()
            Text("빠른 메뉴")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
}

// MARK: - 학생증 요약 + 도서관 예약 현황

private struct IDAndLibrarySection: View {
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "timer")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.indigo)
                    .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text("전자출결")
                        .font(.headline)
                    Text("데이타구조론")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            
            HStack {
                Image(systemName: "book.fill")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text("노트북열람실")
                        .font(.headline)
                    Text("만료까지 44분 남음")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
        }
    }
}

// MARK: - 공지사항 미리보기

private struct NoticePreviewSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("📢 공지사항")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("• [학사] 수강 정정 기간 안내 (4/4~4/10)")
                Text("• [도서관] 시험기간 열람실 연장 운영")
                Text("• [냥대학] 곤지 실종사건")
            }
            .font(.subheadline)
            .foregroundColor(.gray)
        }
    }
}

// MARK: - 주요 메뉴 버튼

private struct QuickMenuSection: View {
    var body: some View {
        VStack(spacing: 16) {
            HomeMenuButton(title: "디지털 학생증", icon: "person.text.rectangle")
            HomeMenuButton(title: "곤지 추적하기", icon: "cat")
        }
    }
}

struct HomeMenuButton: View {
    let title: String
    let icon: String
    
    var body: some View {
        NavigationLink(destination: Text("\(title) 준비중")) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .clipShape(Circle())
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            .shadow(radius: 1)
        }
    }
}

#Preview {
    HomeView()
}

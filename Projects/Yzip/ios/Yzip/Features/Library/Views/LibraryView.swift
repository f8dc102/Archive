//
// LibraryView.swift
// Yzip
//
// Created 4/3/25
// Copyright © 2025 Yzip. All rights reserved.
//

import SwiftUI

struct LibraryView: View {
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("📆 예약 현황")) {
                    ReservationRow(
                        roomName: "6층 개인열람실 A",
                        time: "14:00~16:00"
                    )
                }
                
                Section(header: Text("💺 실시간 좌석 정보")) {
                    SeatStatusRow(
                        roomName: "3층 일반열람실",
                        status: "혼잡"
                    )
                    SeatStatusRow(
                        roomName: "5층 그룹스터디룸",
                        status: "여유"
                    )
                }
                
                Section(header: Text("📢 공지사항")) {
                    NoticeCard(
                        title: "시험기간 야간 개방",
                        detail: "4월 8일 ~ 4월 19일"
                    )
                }
            }
            .navigationTitle("도서관")
        }
    }
}

// MARK: - Custom Views

struct ReservationRow: View {
    let roomName: String
    let time: String
    
    var body: some View {
        HStack {
            Image(systemName: "calendar.badge.clock")
                .foregroundColor(.blue)
            VStack(alignment: .leading) {
                Text(roomName)
                    .font(.headline)
                Text(time)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 4)
    }
}

struct SeatStatusRow: View {
    let roomName: String
    let status: String
    
    var statusColor: Color {
        switch status {
        case "혼잡": return .red
        case "보통": return .orange
        case "여유": return .green
        default: return .gray
        }
    }
    
    var body: some View {
        HStack {
            Image(systemName: "chair")
                .foregroundColor(statusColor)
            Text("\(roomName) - \(status)")
                .foregroundColor(.primary)
        }
        .padding(.vertical, 4)
    }
}

struct NoticeCard: View {
    let title: String
    let detail: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.headline)
                .bold()
            Text(detail)
                .font(.subheadline)
        }
        .padding()
        .background(Color.yellow.opacity(0.2))
        .cornerRadius(8)
    }
}

#Preview {
    LibraryView()
}

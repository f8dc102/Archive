//
// NoticeView.swift
// Yzip
//
// Created 4/3/25
// Copyright © 2025 Yzip. All rights reserved.
//
        

import SwiftUI

struct NoticeView: View {
    var body: some View {
        NavigationStack {
            List {
                Text("📌 [학사공지] 2학기 수강 정정 일정 안내")
                Text("📢 [생활관] 기말고사 기간 출입 시간 연장 안내")
                Text("🚧 [시설공지] 도서관 열람실 정기 점검 (4/7)")
            }
            .navigationTitle("공지사항")
        }
    }
}

#Preview {
    NoticeView()
}

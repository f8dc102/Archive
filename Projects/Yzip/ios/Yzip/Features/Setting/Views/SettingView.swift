//
// SettingView.swift
// Yzip
//
// Created 4/3/25
// Copyright © 2025 Yzip. All rights reserved.
//
        

import SwiftUI

struct SettingView: View {
    @State private var selectedMajor = "소프트웨어학부"

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("연세포탈 계정")) {
                    HStack {
                        Image(systemName: "person.crop.circle")
                        VStack(alignment: .leading) {
                            Text("2023100000")
                            Text("cute_cat@yonsei.ac.kr")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }

                    Button("로그아웃") {
                        print("로그아웃 처리")
                    }
                    .foregroundColor(.red)
                }

                Section(header: Text("공지 설정")) {
                    HStack {
                        Text("공지 수신 여부")
                        Toggle("ON", isOn: .constant(true))
                            .toggleStyle(SwitchToggleStyle())
                    }
                    
                    HStack {
                        Text("단과대학 선택")
                    }
                }
                
                Section(header: Text("앱 정보")) {
                    HStack {
                        Text("버전")
                        Spacer()
                        Text(Config.appVersion ?? "N/A")
                            .foregroundColor(.gray)
                    }

                    HStack {
                        Text("빌드 번호")
                        Spacer()
                        Text(Config.appBuildNumber ?? "N/A")
                            .foregroundColor(.gray)
                    }
                    
                    Button("오픈소스 라이선스 보기") {
                        print("라이선스 보기")
                    }
                    
                    
                }
            }
            .navigationTitle("설정")
        }
    }
}

#Preview {
    SettingView()
}

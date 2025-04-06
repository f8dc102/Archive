//
// SplashView.swift
// Yzip
//
// Created 4/3/25
// Copyright © 2025 Yzip. All rights reserved.
//

import SwiftUI

struct SplashView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var isActive = false
    
    var body: some View {
        Group {
            if isActive {
                /// 모든 기능이 완성되면 탭 뷰 보이기
                // MainTabView()
                TransitView()
            } else {
                VStack {
                    Image("Splash")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 169, height: 169)
                    
                    Text("Yzip")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top, 12)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(colorScheme == .dark ? Color.black : Color.white)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation {
                    isActive = true
                }
            }
        }
    }
}

#Preview {
    SplashView()
}

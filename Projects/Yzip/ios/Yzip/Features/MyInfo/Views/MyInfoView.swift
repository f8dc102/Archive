//
// MyInfoView.swift
// Yzip
//
// Created 4/3/25
// Copyright © 2025 Yzip. All rights reserved.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct MyInfoView: View {
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    var qrImage: Image {
        let data = Data("2023100000".utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        if let outputImage = filter.outputImage {
            let scaled = outputImage.transformed(by: CGAffineTransform(scaleX: 12, y: 12)) // 더 키우기
            if let cgimg = context.createCGImage(scaled, from: scaled.extent) {
                return Image(uiImage: UIImage(cgImage: cgimg))
            }
        }
        
        return Image(systemName: "xmark.circle")
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor.systemGroupedBackground)
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    VStack(spacing: 24) {
                        // 프로필 이미지 + 이름
                        VStack(spacing: 12) {
                            Image("Cat")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                            
                            Text("곤지")
                                .font(.title2)
                                .bold()
                            
                            Text("고양이대학 냥이전공")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        // QR 코드
                        qrImage
                            .interpolation(.none)
                            .resizable()
                            .frame(width: 160, height: 160)
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 2)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("디지털 학생증")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        print("지갑에 추가")
                    }) {
                        Image(systemName: "wallet.pass")
                    }
                    .accessibilityLabel("지갑에 추가")
                }
            }
        }
    }
}

#Preview {
    MyInfoView()
}

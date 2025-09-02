//
//  SplashView.swift
//  MXVideoSaver
//
//  Created by vishva narola on 02/09/25.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    
    var body: some View {
        if isActive {
            TabBarView()
        } else {
            VStack(spacing: 15) {
                Image("ic_appicon")
                    .resizable()
                    .frame(width: 130, height: 130)
                    .foregroundColor(.primary)
            }
            .padding()
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now()+2) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashView()
}

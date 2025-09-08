//
//  TabBarView.swift
//  MXVideoSaver
//
//  Created by vishva narola on 02/09/25.
//

import SwiftUI

enum CustomTab {
    case home, myCollection, settings
}

struct TabBarView: View {
    @ObservedObject var adManager = AdManager.shared
    @State private var selectedTab: CustomTab = .home
    @State private var isTabBarHidden: Bool = false
    @State private var isHiddenBanner: Bool = false
    
    var body: some View {
        VStack {
            Group {
                switch selectedTab {
                case .home:
                    HomeView(isTabBarHidden: $isTabBarHidden, isHiddenBanner: $isHiddenBanner)
                case .myCollection:
                    MyCollectionsView(selectedTab: $selectedTab, isTabBarHidden: $isTabBarHidden, isHiddenBanner: $isHiddenBanner)
                case .settings:
                    SettingsView()
                }
            }
            VStack(spacing: 0) {
                if !isTabBarHidden {
                    HStack {
                        tabBarItem(tab: .home, icon: "ic_selected_home", deselectIcon: "ic_deselected_home", label: "Home")
                        Spacer()
                        tabBarItem(tab: .myCollection, icon: "ic_selected_collection", deselectIcon: "ic_deselected_collection", label: "My Files")
                        Spacer()
                        tabBarItem(tab: .settings, icon: "ic_selected_settings", deselectIcon: "ic_deselected_settings", label: "Lock")
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(
                        pinkThemeColor
                    )
                }
            }
        }
        .ignoresSafeArea()
    }
    
    @ViewBuilder
    private func tabBarItem(tab: CustomTab, icon: String, deselectIcon: String, label: String) -> some View {
        let isSelected = selectedTab == tab
        Image(isSelected ? icon : deselectIcon)
            .resizable()
            .frame(width: 30, height: 30)
            .frame(width: 70, height: 70)
            .onTapGesture {
                AdManager.shared.showInterstitialAd()
                withAnimation {
                    selectedTab = tab
                }
            }
    }
}

#Preview {
    TabBarView()
}

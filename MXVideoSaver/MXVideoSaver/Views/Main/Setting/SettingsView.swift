//
//  SettingsView.swift
//  MXVideoSaver
//
//  Created by vishva narola on 02/09/25.
//

import SwiftUI

enum SettingsRoute: Hashable {
    case premium
}

enum SettingsTool: String {
    case share_app
    case rate_us
    case terms_conditions
    case privacy_policy
}

struct SettingsView: View {
    @Environment(\.openURL) var openURL
    @State private var navigationPath = NavigationPath()
    @State private var showNoInternetAlert: Bool = false
    @State private var isShowingShareSheet = false
    @Binding var selectedTab: CustomTab
    @Binding var isTabBarHidden: Bool
    @Binding var isHiddenBanner: Bool
    @ObservedObject var adManager = AdManager.shared
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 20) {
                headerView
                if !PremiumManager.shared.isPremium {
                    premiumView
                }
                ScrollView {
                    moreOptionsView
                }
                .padding(.horizontal, 20)
                if let isShowNativeSettings = remoteConfigModel?.isShowNativeSettings, isShowNativeSettings == true && !PremiumManager.shared.isPremium {
                    nativeAdView
                }
                Spacer()
            }
            .ignoresSafeArea()
            .navigationBarBackButtonHidden(true)
            .navigationDestination(for: SettingsRoute.self) { route in
                switch route {
                case .premium:
                    PremiumView(isTabBarHidden: $isTabBarHidden, navigationPath: $navigationPath, isHiddenBanner: $isHiddenBanner)
                        .navigationBarBackButtonHidden(true)
                }
            }
            .noInternetAlert(isPresented: $showNoInternetAlert)
            .sheet(isPresented: $isShowingShareSheet) {
                if let appUrl = appLink {
                    ActivityView(activityItems: [appUrl])
                }
            }
        }
    }
    
    var headerView: some View {
        HeaderView(
            leftButtonImageName: "ic_back",
            rightButtonImageName: nil,
            headerTitle: "Settings",
            leftButtonAction: {
                AdManager.shared.showInterstitialAd()
                isTabBarHidden = false
                navigationPath.removeLast()
            },
            rightButtonAction: nil
        )
    }
    
    var premiumView: some View {
        Button {
            if ReachabilityManager.shared.isNetworkAvailable {
                AdManager.shared.showInterstitialAd()
                isHideTabBackPremium = false
                isTabBarHidden = true
                navigationPath.append(SettingsRoute.premium)
            } else {
                showNoInternetAlert = true
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color(red: 251/255, green: 47/255, blue: 72/255))
                    .frame(maxWidth: .infinity)
                    .frame(height: 100)
                    .offset(y: 20)
                HStack(spacing: 0) {
                    Image("ic_crown")
                    VStack(alignment: .leading, spacing: 9) {
                        Text("Get Premium")
                            .font(FontConstants.SyneFonts.medium(size: 22))
                            .foregroundStyle(Color.black)
                        Text("Get full access to all our features")
                            .font(FontConstants.SyneFonts.regular(size: 18))
                            .foregroundStyle(Color.black.opacity(0.7))
                    }
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal, 25)
                    .padding(.vertical, 20)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .background(Color(red: 1.0, green: 140/255, blue: 154/255))
                .cornerRadius(30)
                .clipped()
            }
            .padding(.horizontal, 20)
        }
    }
    
    var moreOptionsView: some View {
        VStack(alignment: .leading, spacing: 15) {
            VStack(spacing: 20) {
                options(image: "ic_rate_us", text: "Rate Us") {
                    if let url = appRateLink {
                        openUrls(url)
                    }
                }
                options(image: "ic_privacy_policy", text: "Privacy & Policy") {
                    if let url = privacyPolicy {
                        openUrls(url)
                    }
                }
                options(image: "ic_terms_conditions", text: "Terms & Condition") {
                    if let url = termsCondition {
                        openUrls(url)
                    }
                }
            }
            .padding(.vertical, 25)
            .background(textGrayColor.opacity(0.10))
            .cornerRadius(20)
            VStack(spacing: 18) {
                options(image: "ic_share_app", text: "Share App") {
                    isShowingShareSheet = true
                }
            }
            .padding(.vertical, 20)
            .background(textGrayColor.opacity(0.10))
            .cornerRadius(20)
        }
        .padding(.top, 10)
    }
    
    func options(image: String, text: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            HStack(spacing: 26) {
                Image(image)
                    .resizable()
                    .frame(width: 45, height: 45)
                Text(text)
                    .font(FontConstants.MontserratFonts.medium(size: 18))
                    .foregroundStyle(Color.black)
                Spacer()
            }
            .padding(.leading, 28)
        }
    }
    
    func openUrls(_ url: URL) {
        if ReachabilityManager.shared.isNetworkAvailable {
            openURL(url)
        } else {
            showNoInternetAlert = true
        }
    }
    
    var nativeAdView: some View {
        Group {
            GADNativeViewControllerWrapper()
                .padding(.horizontal, 20)
                .padding(.top)
        }
    }
}

#Preview {
    SettingsView(selectedTab: .constant(.settings), isTabBarHidden: .constant(false), isHiddenBanner: .constant(false))
}

//
//  PremiumView.swift
//  MXVideoSaver
//
//  Created by vishva narola on 02/09/25.
//

import SwiftUI
import RevenueCat

struct PremiumView: View {
    @ObservedObject private var premiumManager = PremiumManager.shared
    @Environment(\.openURL) var openURL
    @State private var selectedPlanIndex = 0
    @State private var isPurchasing = false
    @State private var activeAlert: PremiumAlertType?
    @Binding var isTabBarHidden: Bool
    @Binding var navigationPath: NavigationPath
    @Binding var isHiddenBanner: Bool
    
    var body: some View {
        ZStack {
            backgroundView.ignoresSafeArea()
            
            VStack(spacing: 0) {
                restoreView
                
                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 30) {
                            headerView
                            featuresView
                            subscriptionPlansView
                            Color.clear.frame(height: 1).id("BOTTOM")
                        }
                        .padding(.top, 10)
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                            withAnimation(.easeOut(duration: 2)) {
                                proxy.scrollTo("BOTTOM", anchor: .bottom)
                            }
                        }
                    }
                }
                
                VStack(spacing: 16) {
                    subscribeNowButton
                    footerView
                }
                .padding(.bottom)
            }
            .padding(.horizontal, 20)
        }
        .onAppear {
            isHiddenBanner = true
            if premiumManager.products.isEmpty {
                premiumManager.fetchProducts()
            }
        }
        .onDisappear {
            isHiddenBanner = false
        }
        .alert(item: $activeAlert) { alert in
            Alert(
                title: Text(alert.title),
                message: Text(alert.message),
                dismissButton: .default(Text("OK")) {
                    if case .success = alert {
                        isTabBarHidden = isHideTabBackPremium
                        navigationPath.removeLast()
                    } else if case .restore = alert {
                        isTabBarHidden = isHideTabBackPremium
                        navigationPath.removeLast()
                    }
                }
            )
        }
    }
    
    var backgroundView: some View {
        ZStack(alignment: .top) {
            Color.black
            Image("ic_premium_bg")
            Color.black.opacity(0.5)
            LinearGradient(
                gradient: Gradient(colors: [.clear, .black, .black]),
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
    
    var restoreView: some View {
        HStack {
            if restoreShow {
                Button {
                    premiumManager.restorePurchases { success, error in
                        DispatchQueue.main.async {
                            if success {
                                premiumManager.checkPremiumStatus()
                                activeAlert = .restore("Enjoy app without ads!")
                            } else {
                                activeAlert = .error(error ?? "Restore failed.")
                            }
                        }
                    }
                } label: {
                    Text("Restore")
                        .font(FontConstants.SyneFonts.medium(size: 20))
                        .foregroundStyle(textGrayColor)
                }
            }
            Spacer()
            Button {
                AdManager.shared.showInterstitialAd()
                isTabBarHidden = isHideTabBackPremium
                navigationPath.removeLast()
            } label: {
                Image("ic_close")
                    .resizable()
                    .scaledToFit()
            }
            .frame(width: 25, height: 25)
        }
        .padding(.top)
    }
    
    var headerView: some View {
        VStack(spacing: 10) {
            Image("ic_premium")
                .padding(.bottom, 10)
            Text("Unlock Premium")
                .font(FontConstants.SyneFonts.semiBold(size: 35))
                .foregroundStyle(pinkThemeColor)
            Text("access now")
                .font(FontConstants.SyneFonts.semiBold(size: 25))
                .foregroundStyle(.white)
        }
    }
    
    var featuresView: some View {
        VStack(spacing: 16) {
            featureView(text: "HD Quality")
            featureView(text: "Ads Free 100%")
            featureView(text: "Unlimited all Access")
            featureView(text: "High Speed Connectivity")
            featureView(text: "Tending Hashtag")
        }
    }
    
    func featureView(text: String) -> some View {
        HStack(spacing: 15) {
            Image("ic_check")
            Text(text)
                .font(FontConstants.SyneFonts.medium(size: 20))
                .foregroundStyle(.white)
            Spacer()
        }
    }
    
    var subscriptionPlansView: some View {
        VStack(spacing: 10) {
            ForEach(Array(premiumManager.products.enumerated()), id: \.element.productIdentifier) { index, product in
                Button {
                    AdManager.shared.showInterstitialAd()
                    selectedPlanIndex = index
                } label: {
                    SubscriptionPlanCell(
                        product: product,
                        isSelected: selectedPlanIndex == index
                    )
                }
            }
        }
    }
    
    var subscribeNowButton: some View {
        Button {
            guard premiumManager.products.indices.contains(selectedPlanIndex) else { return }
            let product = premiumManager.products[selectedPlanIndex]
            
            isPurchasing = true
            premiumManager.purchase(product: product) { success, error in
                DispatchQueue.main.async {
                    isPurchasing = false
                    if success {
                        premiumManager.checkPremiumStatus()
                        activeAlert = .success("Enjoy app without ads!")
                    } else {
                        activeAlert = .error(error ?? "Purchase failed.")
                    }
                }
            }
        } label: {
            Text("Subscribe Now")
                .font(FontConstants.MontserratFonts.semiBold(size: 18))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(pinkThemeColor)
                .cornerRadius(20)
        }
        .disabled(isPurchasing || premiumManager.isLoadingProducts)
    }
    
    var footerView: some View {
        HStack(spacing: 0) {
            Button {
                if let url = privacyPolicy {
                    openURL(url)
                }
            } label: { Text("▪︎  Privacy & Policy") }
            Spacer()
            Button {
                if let url = termsCondition {
                    openURL(url)
                }
            } label: { Text("▪︎  Terms & Condition") }
            Spacer()
            Button {
                if let url = EULA {
                    openURL(url)
                }
            } label: { Text("▪︎  EULA") }
        }
        .font(FontConstants.SyneFonts.light(size: 14))
        .foregroundStyle(.white)
    }
}

struct SubscriptionPlanCell: View {
    let product: StoreProduct
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Weekly")
                .font(FontConstants.SyneFonts.semiBold(size: 18))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .background(isSelected ? Color.clear : pinkThemeColor)
            if !isSelected {
                Rectangle()
                    .fill(textGrayColor)
                    .frame(height: 0.4)
            }
            VStack(spacing: 10) {
                Text("₹199.00/")
                    .font(FontConstants.MontserratFonts.semiBold(size: 20))
                    .foregroundColor(isSelected ? pinkThemeColor : .white)
                Text("₹199.00/week")
                    .font(FontConstants.MontserratFonts.medium(size: 12))
                    .foregroundColor(isSelected ? Color.white : textGrayColor)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(Color.black)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? pinkThemeColor : textGrayColor, lineWidth: 1)
        )
        .cornerRadius(10)
    }
}

#Preview {
    PremiumView(isTabBarHidden: .constant(false), navigationPath: .constant(NavigationPath()), isHiddenBanner: .constant(false))
}

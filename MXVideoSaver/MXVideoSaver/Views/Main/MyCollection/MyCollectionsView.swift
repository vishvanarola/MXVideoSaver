//
//  MyCollectionsView.swift
//  MXVideoSaver
//
//  Created by vishva narola on 02/09/25.
//

import SwiftUI
import SwiftData

enum MyCollectionRoute: Hashable {
    case photosCollage(Collage)
    case premium
}

struct MyCollectionsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Collage.createdAt, order: .reverse) private var collages: [Collage]
    @State private var showCreateCollage = false
    @State private var collageToEdit: Collage? = nil
    @State private var navigationPath = NavigationPath()
    @State private var showNoInternetAlert: Bool = false
    @Binding var selectedTab: CustomTab
    @Binding var isTabBarHidden: Bool
    @Binding var isHiddenBanner: Bool
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                VStack {
                    headerView
                    listView
                }
                .ignoresSafeArea()
                .navigationBarBackButtonHidden(true)
                
                if showCreateCollage {
                    CreateCollageView(isPresented: $showCreateCollage, collageToEdit: collageToEdit, isTabBarHidden: $isTabBarHidden, navigationPath: $navigationPath)
                }
            }
            .navigationDestination(for: MyCollectionRoute.self) { route in
                switch route {
                case .photosCollage(let collage):
                    PhotosCollageView(collage: collage, isTabBarHidden: $isTabBarHidden, navigationPath: $navigationPath)
                case .premium:
                    PremiumView(isTabBarHidden: $isTabBarHidden, navigationPath: $navigationPath, isHiddenBanner: $isHiddenBanner)
                        .navigationBarBackButtonHidden(true)
                }
            }
            .noInternetAlert(isPresented: $showNoInternetAlert)
        }
    }
    
    var headerView: some View {
        HeaderView(
            leftButtonImageName: "ic_back",
            rightButtonImageName: "ic_plus",
            headerTitle: "My Collection",
            leftButtonAction: {
                AdManager.shared.showInterstitialAd()
                withAnimation {
                    selectedTab = .home
                }
            },
            rightButtonAction: {
                if ReachabilityManager.shared.isNetworkAvailable {
                    AdManager.shared.showInterstitialAd()
                    withAnimation {
                        showCreateCollage = true
                        collageToEdit = nil
                    }
                } else {
                    showNoInternetAlert = true
                }
            }
        )
    }
    
    var listView: some View {
        Group {
            if collages.isEmpty {
                emptyStateView
            } else {
                ScrollView {
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 3),
                        spacing: 20
                    ) {
                        ForEach(collages) { collage in
                            VStack {
                                Image("ic_folder")
                                Text(collage.name)
                                    .font(FontConstants.MontserratFonts.medium(size: 14))
                                    .foregroundStyle(Color.black)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                            .frame(maxWidth: .infinity)
                            .cornerRadius(12)
                            .onTapGesture {
                                if ReachabilityManager.shared.isNetworkAvailable {
                                    AdManager.shared.showInterstitialAd()
                                    isTabBarHidden = true
                                    navigationPath.append(MyCollectionRoute.photosCollage(collage))
                                } else {
                                    showNoInternetAlert = true
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 10)
                }
            }
        }
    }
    
    var emptyStateView: some View {
        VStack {
            Spacer()
            Image("ic_noData")
            Spacer()
        }
        .padding(.bottom, 50)
    }
    
    private func deleteCollage(_ collage: Collage) {
        modelContext.delete(collage)
        do {
            try modelContext.save()
        } catch {
            print("Failed to delete collage: \(error)")
        }
    }
}

#Preview {
    MyCollectionsView(selectedTab: .constant(.myCollection), isTabBarHidden: .constant(false), isHiddenBanner: .constant(false))
}

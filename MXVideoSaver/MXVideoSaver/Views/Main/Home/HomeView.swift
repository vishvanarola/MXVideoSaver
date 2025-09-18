//
//  HomeView.swift
//  MXVideoSaver
//
//  Created by vishva narola on 02/09/25.
//

import SwiftUI

enum HomeDestination: Hashable {
    case repeatText
    case emojiText
    case stylishText
    case directText
    case flipText
    case hashtag
    case premium
}

struct HomeView: View {
    @StateObject private var videoManager = VideoLibraryManager()
    @State private var navigationPath = NavigationPath()
    @State private var showNoInternetAlert: Bool = false
    @State private var enterTextInput: String = ""
    @State private var showToast = false
    @State private var toastText: String = "Copied"
    @Binding var isTabBarHidden: Bool
    @Binding var isHiddenBanner: Bool
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                VStack {
                    headerView
                    textFieldFindView
                    ScrollView {
                        tools
                        videoListView
                    }
                    Spacer()
                }
                if showToast {
                    VStack {
                        Spacer()
                        Text(toastText)
                            .font(FontConstants.MontserratFonts.medium(size: 17))
                            .padding()
                            .background(Color.black.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                            .padding(.bottom, 20)
                    }
                }
            }
            .ignoresSafeArea()
            .onAppear {
                videoManager.fetchVideos()
                if appComesFirst && !PremiumManager.shared.isPremium {
                    appComesFirst = false
                    isHideTabBackPremium = false
                    isTabBarHidden = true
                    navigationPath.append(HomeDestination.premium)
                }
            }
            .navigationDestination(for: HomeDestination.self) { destination in
                switch destination {
                case .repeatText: RepeatTextView(isTabBarHidden: $isTabBarHidden, navigationPath: $navigationPath)
                        .navigationBarBackButtonHidden(true)
                case .emojiText: EmojiTextView(isTabBarHidden: $isTabBarHidden, navigationPath: $navigationPath)
                        .navigationBarBackButtonHidden(true)
                case .stylishText: StylishTextView(isTabBarHidden: $isTabBarHidden, navigationPath: $navigationPath)
                        .navigationBarBackButtonHidden(true)
                case .directText: DirectChatView(isTabBarHidden: $isTabBarHidden, navigationPath: $navigationPath)
                        .navigationBarBackButtonHidden(true)
                case .flipText: FlipTextView(isTabBarHidden: $isTabBarHidden, navigationPath: $navigationPath)
                        .navigationBarBackButtonHidden(true)
                case .hashtag: HashtagView(isTabBarHidden: $isTabBarHidden, navigationPath: $navigationPath)
                        .navigationBarBackButtonHidden(true)
                case .premium: PremiumView(isTabBarHidden: $isTabBarHidden, navigationPath: $navigationPath, isHiddenBanner: $isHiddenBanner)
                        .navigationBarBackButtonHidden(true)
                }
            }
        }
    }
    
    var headerView: some View {
        VStack {
            Spacer()
            HStack(spacing: 15) {
                Text(homeAppName)
                    .font(FontConstants.SyneFonts.semiBold(size: 23))
                    .foregroundStyle(Color.white)
                Spacer()
                if !PremiumManager.shared.isPremium {
                    Button {
                        if ReachabilityManager.shared.isNetworkAvailable {
                            isHideTabBackPremium = false
                            isTabBarHidden = true
                            navigationPath.append(HomeDestination.premium)
                        } else {
                            showNoInternetAlert = true
                        }
                    } label: {
                        Image("ic_pro")
                            .resizable()
                            .frame(width: 70, height: 30)
                    }
                }
                Button {
                    if ReachabilityManager.shared.isNetworkAvailable {
                        isHideTabBackPremium = false
                        isTabBarHidden = true
                        navigationPath.append(HomeDestination.premium)
                    } else {
                        showNoInternetAlert = true
                    }
                } label: {
                    Image("ic_favourite")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 30, height: 30)
                }
            }
            .padding(.bottom, 20)
        }
        .frame(height: UIScreen.main.bounds.height * 0.15)
        .padding(.horizontal, 20)
        .background(redThemeColor)
    }
    
    var textFieldFindView: some View {
        VStack(spacing: 18) {
            ZStack(alignment: .topTrailing) {
                textFieldView
                if !PremiumManager.shared.isPremium {
                    Image("ic_text_pro")
                        .padding(.top, 10)
                        .padding(.trailing, 120)
                }
            }
            findButtonView
        }
    }
    
    var textFieldView: some View {
        HStack(spacing: 20) {
            TextField("", text: $enterTextInput, prompt: Text("Enter or Paste URL")
                .font(FontConstants.MontserratFonts.medium(size: 18))
                .foregroundColor(.gray)
            )
            .font(FontConstants.MontserratFonts.semiBold(size: 18))
            .keyboardType(.URL)
            .padding(13)
            Button {
                if !enterTextInput.isEmpty {
                    toastText = "Copied"
                    UIPasteboard.general.string = enterTextInput
                    showToasts()
                }
            } label: {
                Image("ic_copy")
            }
            .padding(.trailing, 10)
        }
        .padding(.horizontal, 10)
        .frame(height: 50)
        .background(.gray.opacity(0.05))
        .background(.white)
        .cornerRadius(30)
        .shadow(radius: 3)
        .padding(.top, 20)
        .padding(.horizontal, 20)
    }
    
    var findButtonView: some View {
        Button {
            if self.isValidURLRegex(enterTextInput) {
                if PremiumManager.shared.isPremium {
                    
                } else {
                    isHideTabBackPremium = false
                    isTabBarHidden = true
                    navigationPath.append(HomeDestination.premium)
                }
            } else {
                toastText = "Plase enter a valid URL"
                showToasts()
            }
            
        } label: {
            Text("Find your Video")
                .font(FontConstants.MontserratFonts.medium(size: 18))
                .foregroundStyle(.white)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(pinkThemeColor)
                )
                .cornerRadius(30)
        }
        .padding(.horizontal, 20)
    }
    
    var tools: some View {
        VStack(spacing: 16) {
            HStack {
                Text("More Tools")
                    .font(FontConstants.MontserratFonts.semiBold(size: 20))
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.horizontal, 20)
            HStack(spacing: 16) {
                tool(image: "ic_repeat_text", text: "Repeat Text", destination: .repeatText)
                tool(image: "ic_emoji_text", text: "Emoji Text", destination: .emojiText)
                tool(image: "ic_stylish_text", text: "Stylish Text", destination: .stylishText)
            }
            HStack(spacing: 16) {
                tool(image: "ic_direct_chat", text: "Direct Chat", destination: .directText)
                tool(image: "ic_flip_text", text: "Flip Text", destination: .flipText)
                tool(image: "ic_hashtag", text: "Hashtag", destination: .hashtag)
            }
        }
        .padding(.top, 10)
    }
    
    func tool(image: String, text: String, destination: HomeDestination) -> some View {
        VStack {
            Button {
                isTabBarHidden = true
                AdManager.shared.showInterstitialAd()
                navigationPath.append(destination)
            } label: {
                Image(image)
                    .resizable()
                    .frame(width: 70, height: 70)
                    .padding()
            }
            .background(pinkThemeColor.opacity(0.05))
            .cornerRadius(15)
            Text(text)
                .font(FontConstants.MontserratFonts.medium(size: 14))
                .foregroundColor(.black)
        }
    }
    
    var videoListView: some View {
        VStack {
            HStack {
                Text("Videos")
                    .font(FontConstants.MontserratFonts.semiBold(size: 20))
                    .foregroundColor(.black)
                    .padding(.top, 30)
                Spacer()
            }
            .padding(.horizontal, 20)
            if videoManager.videos.count <= 0 {
                VStack {
                    Spacer()
                    emptyStateView
                    Spacer()
                }
            } else {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(videoManager.videos, id: \.self) { video in
                        VideoThumbnailViewNewHome(videoData: video)
                            .padding(.horizontal, 20)
                    }
                }
            }
        }
    }
    
    var emptyStateView: some View {
        VStack {
            Spacer()
            Text("No Data Found")
                .font(FontConstants.MontserratFonts.medium(size: 20))
                .foregroundColor(.black.opacity(0.30))
            Spacer()
        }
        .padding(.top, 50)
        .padding(.bottom, 50)
    }
    
    func showToasts() {
        withAnimation {
            showToast = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                showToast = false
            }
        }
    }
    
    func isValidURLRegex(_ urlString: String) -> Bool {
        let pattern = #"^(http|https)://([\w-]+(\.[\w-]+)+)([/#?]?.*)$"#
        return urlString.range(of: pattern, options: .regularExpression) != nil
    }
}

struct VideoThumbnailViewNewHome: View {
    @State var videoData: VideosArrayData?
    @State private var isPresentingPlayer = false
    @State private var showNoInternetAlert: Bool = false
    
    var body: some View {
        ZStack {
            Image("ic_collectionBack")
                .resizable()
                .frame(maxWidth: .infinity)
                .frame(height: 80)
            HStack(spacing: 15) {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(.black.opacity(0.1))
                    AsyncImage(url: URL(string: videoData?.videoThumb ?? "")) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .clipped()
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(width: 60, height: 60)
                    .cornerRadius(10)
                }
                .frame(width: 60, height: 60)
                VStack(alignment: .leading, spacing: 5) {
                    Text(videoData?.title ?? "Video Name")
                        .font(FontConstants.MontserratFonts.medium(size: 18))
                        .foregroundStyle(Color.black)
                        .lineLimit(2)
                    Text(videoData?.size ?? "0 KB")
                        .font(FontConstants.MontserratFonts.medium(size: 14))
                        .foregroundStyle(Color.gray.opacity(0.5))
                        .lineLimit(1)
                }
                Spacer()
            }
            .padding()
        }
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .frame(height: 80)
        .background(.white)
        .cornerRadius(15)
        .shadow(radius: 2)
        .padding(.bottom, 10)
        .onTapGesture {
            if ReachabilityManager.shared.isNetworkAvailable {
                isPresentingPlayer = true
            } else {
                showNoInternetAlert = true
            }
        }
        .sheet(isPresented: $isPresentingPlayer) {
            if let urlString = videoData?.videoUrl, let url = URL(string: urlString) {
                VideoPlayerView(videoURL: url)
            } else {
                Text("Invalid video URL")
            }
        }
        .noInternetAlert(isPresented: $showNoInternetAlert)
    }
}

#Preview {
    HomeView(isTabBarHidden: .constant(false), isHiddenBanner: .constant(false))
}

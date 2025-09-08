//
//  FlipTextView.swift
//  MXVideoSaver
//
//  Created by vishva narola on 02/09/25.
//

import SwiftUI

struct FlipTextView: View {
    @State private var enterTextInput: String = ""
    @State private var outputText: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showNoInternetAlert: Bool = false
    @State private var showToast = false
    @Binding var isTabBarHidden: Bool
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                headerView
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        enterTextView
                        outputTextView
                        outputButton
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical)
                }
            }
            if showToast {
                VStack {
                    Spacer()
                    Text("Copied")
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
        .onTapGesture {
            UIApplication.shared.hideKeyboard()
        }
        .ignoresSafeArea()
        .noInternetAlert(isPresented: $showNoInternetAlert)
    }
    
    var headerView: some View {
        HeaderView(
            leftButtonImageName: "ic_back",
            rightButtonImageName: nil,
            headerTitle: "Flip Text",
            leftButtonAction: {
                AdManager.shared.showInterstitialAd()
                isTabBarHidden = false
                navigationPath.removeLast()
            },
            rightButtonAction: nil
        )
    }
    
    var enterTextView: some View {
        TextFieldView(headerTitle: "Enter Text", placeholder: "Enter text here..", text: $enterTextInput)
    }
    
    var outputTextView: some View {
        ZStack(alignment: .topTrailing) {
            TextEditor(text: $outputText)
                .scrollContentBackground(.hidden)
                .font(FontConstants.MontserratFonts.medium(size: 18))
                .foregroundStyle(.black)
            
            if !outputText.isEmpty {
                HStack {
                    Button {
                        if !outputText.isEmpty {
                            UIPasteboard.general.string = outputText
                            withAnimation {
                                showToast = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    showToast = false
                                }
                            }
                        }
                    } label: {
                        Image("ic_text_copy")
                    }
                    Button {
                        ShareHelper.share([outputText])
                    } label: {
                        Image("ic_text_share")
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .cornerRadius(10)
        .frame(height: 250)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(redThemeColor, lineWidth: 1)
        )
        .background(pinkThemeColor.opacity(0.05))
    }
    
    var outputButton: some View {
        Button {
            if ReachabilityManager.shared.isNetworkAvailable {
                validateAndGenerateText()
            } else {
                showNoInternetAlert = true
                
            }
        } label: {
            Text("Reverse")
                .font(FontConstants.MontserratFonts.medium(size: 18))
                .foregroundStyle(.white)
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(pinkThemeColor)
                .cornerRadius(10)
        }
        .padding(.bottom, 5)
        .padding(.horizontal, 20)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Invalid Input"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func validateAndGenerateText() {
        guard !enterTextInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertMessage = "Please enter some text to flip."
            showAlert = true
            return
        }
        
        if PremiumManager.shared.isPremium || !PremiumManager.shared.hasUsed() {
            AdManager.shared.showInterstitialAd()
            generateReversedText()
            PremiumManager.shared.markUsed()
        } else {
            navigationPath.append(HomeDestination.premium)
        }
    }
    
    private func generateReversedText() {
        let trimmedInput = enterTextInput.trimmingCharacters(in: .whitespacesAndNewlines)
        outputText = String(trimmedInput.reversed())
        PremiumManager.shared.markUsed()
    }
}

#Preview {
    FlipTextView(isTabBarHidden: .constant(true), navigationPath: .constant(NavigationPath()))
}

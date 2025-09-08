//
//  DirectChatView.swift
//  MXVideoSaver
//
//  Created by vishva narola on 02/09/25.
//

import SwiftUI
import MessageUI

struct DirectChatView: View {
    @State private var enterTextInput: String = ""
    @State private var messageText: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showNoInternetAlert: Bool = false
    @State private var showToast = false
    @State private var countryCode: String = ""
    @State private var showMessageComposer = false
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
        .onAppear {
            let regionCode = Locale.current.region?.identifier ?? "US"
            let phoneCode = countryDialingCodes[regionCode] ?? "+1"
            countryCode = phoneCode
        }
        .ignoresSafeArea()
        .noInternetAlert(isPresented: $showNoInternetAlert)
        .sheet(isPresented: $showMessageComposer) {
            MessageComposer(
                recipients: [countryCode + enterTextInput],
                body: messageText
            )
        }
    }
    
    var headerView: some View {
        HeaderView(
            leftButtonImageName: "ic_back",
            rightButtonImageName: nil,
            headerTitle: "Direct Chat",
            leftButtonAction: {
                AdManager.shared.showInterstitialAd()
                isTabBarHidden = false
                navigationPath.removeLast()
            },
            rightButtonAction: nil
        )
    }
    
    var enterTextView: some View {
        HStack {
            Text(countryCode)
                .font(FontConstants.MontserratFonts.semiBold(size: 20))
                .foregroundStyle(.black)
            Rectangle()
                .fill(textGrayColor)
                .frame(width: 2)
                .padding(.horizontal, 10)
            TextField("", text: $enterTextInput, prompt: Text("Enter Mobile Number")
                .font(FontConstants.MontserratFonts.medium(size: 16))
                .foregroundColor(.gray)
            )
            .font(FontConstants.MontserratFonts.medium(size: 16))
            .keyboardType(.phonePad)
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(pinkThemeColor, lineWidth: 1)
        )
        .background(pinkThemeColor.opacity(0.05))
    }
    
    var outputTextView: some View {
        ZStack(alignment: .topLeading) {
            if messageText.isEmpty {
                Text("Type Message...")
                    .font(FontConstants.MontserratFonts.medium(size: 18))
                    .foregroundColor(textGrayColor)
                    .padding()
                    .padding(.top, 5)
                    .padding(.leading, 7)
            }
            TextEditor(text: $messageText)
                .scrollContentBackground(.hidden)
                .font(FontConstants.MontserratFonts.medium(size: 18))
                .foregroundColor(.black)
                .padding()
        }
        .frame(height: 250)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(redThemeColor, lineWidth: 1)
        )
        .background(pinkThemeColor.opacity(0.05))
        .cornerRadius(10)
    }
    
    var outputButton: some View {
        Button {
            if ReachabilityManager.shared.isNetworkAvailable {
                validate()
            } else {
                showNoInternetAlert = true
            }
        } label: {
            Text("Message")
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
    
    private func validate() {
        guard !enterTextInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertMessage = "Please enter mobile number"
            showAlert = true
            return
        }
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            alertMessage = "Please enter some text to send message."
            showAlert = true
            return
        }
        
        if PremiumManager.shared.isPremium || !PremiumManager.shared.hasUsed() {
            AdManager.shared.showInterstitialAd()
            directChat()
            PremiumManager.shared.markUsed()
        } else {
            navigationPath.append(HomeDestination.premium)
        }
    }
    
    private func directChat() {
        let fullNumber = countryCode + enterTextInput
        
        if MFMessageComposeViewController.canSendText() {
            showMessageComposer = true
            PremiumManager.shared.markUsed()
        } else {
            alertMessage = "This device cannot send SMS."
            showAlert = true
        }
    }
}

#Preview {
    DirectChatView(isTabBarHidden: .constant(true), navigationPath: .constant(NavigationPath()))
}

//
//  EmojiTextView.swift
//  MXVideoSaver
//
//  Created by vishva narola on 02/09/25.
//

import SwiftUI

struct EmojiTextView: View {
    @State private var enterTextInput: String = ""
    @State private var emojiInput: String = "😀"
    @State private var outputText: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showNoInternetAlert: Bool = false
    @State private var showToast = false
    @Binding var isTabBarHidden: Bool
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        ZStack {
            VStack {
                headerView
                ScrollView {
                    VStack(alignment: .leading, spacing: 25) {
                        enterTextView
                        enterEmojiView
                        outputButton
                        outputTextView
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
            headerTitle: "Text to Emoji",
            leftButtonAction: {
                AdManager.shared.showInterstitialAd()
                isTabBarHidden = false
                navigationPath.removeLast()
            },
            rightButtonAction: nil
        )
    }
    
    var enterTextView: some View {
        TextFieldView(headerTitle: "Enter Text", placeholder: "Enter text here", text: $enterTextInput)
    }
    
    var enterEmojiView: some View {
        HStack {
            Text("Set Your Favorite Emoji :")
                .font(FontConstants.MontserratFonts.bold(size: 18))
                .foregroundStyle(.black)
            Spacer()
            TextField("", text: $emojiInput, prompt: Text("😀")
                .font(FontConstants.MontserratFonts.bold(size: 25))
                .foregroundColor(.gray)
            )
            .multilineTextAlignment(.center)
            .font(FontConstants.MontserratFonts.bold(size: 25))
            .keyboardType(.default)
            .onChange(of: emojiInput) { oldValue, newValue in
                let filtered = newValue.filter { $0.isEmoji }
                if let lastEmoji = filtered.last {
                    emojiInput = String(lastEmoji)
                } else {
                    emojiInput = ""
                }
            }
            .frame(width: 50, height: 50)
            .background(pinkThemeColor.opacity(0.10))
            .cornerRadius(15)
        }
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
                validateAndGenerateEmojiText()
            } else {
                showNoInternetAlert = true
            }
        } label: {
            Text("Generate")
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
    
    private func validateAndGenerateEmojiText() {
        let trimmedText = enterTextInput.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmoji = emojiInput.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedText.isEmpty else {
            alertMessage = "Please enter text to convert into emojis."
            showAlert = true
            return
        }
        
        guard !trimmedEmoji.isEmpty else {
            alertMessage = "Please enter at least one emoji."
            showAlert = true
            return
        }
        
        // Optional: Validate if emoji input is emoji-like
        let emojiRegex = #"^\p{Emoji}+$"#
        if trimmedEmoji.range(of: emojiRegex, options: .regularExpression) == nil {
            alertMessage = "Please enter a valid emoji character."
            showAlert = true
            return
        }
        
        if PremiumManager.shared.isPremium || !PremiumManager.shared.hasUsed() {
            AdManager.shared.showInterstitialAd()
            generateEmojiText()
            PremiumManager.shared.markUsed()
        } else {
            navigationPath.append(HomeDestination.premium)
        }
    }
    
    private func generateEmojiText() {
        let text = enterTextInput.uppercased()
        let emoji = emojiInput
        
        var result = ""
        
        for character in text {
            if character.isLetter {
                result += emojiPattern(for: String(character), e: emoji)
                result += "\n\n"
            }
        }
        
        outputText = result
    }
    
    func emojiPattern(for letter: String, e: String) -> String {
        guard !e.isEmpty else { return "" }
        PremiumManager.shared.markUsed()
        
        switch letter.uppercased() {
        case "A":
            return """
              \(e)\(e)
             \(e)  \(e)
            \(e)\(e)\(e)
            \(e)     \(e)
            \(e)     \(e)
            """
        case "B":
            return """
            \(e)\(e)
            \(e)   \(e)
            \(e)\(e)
            \(e)   \(e)
            \(e)\(e)
            """
        case "C":
            return """
              \(e)\(e)\(e)
            \(e)
            \(e)
            \(e)
              \(e)\(e)\(e)
            """
        case "D":
            return """
            \(e)\(e)
            \(e)   \(e)
            \(e)    \(e)
            \(e)   \(e)
            \(e)\(e)
            """
        case "E":
            return """
            \(e)\(e)\(e)
            \(e)
            \(e)\(e)
            \(e)
            \(e)\(e)\(e)
            """
        case "F":
            return """
            \(e)\(e)\(e)
            \(e)
            \(e)\(e)
            \(e)
            \(e)
            """
        case "G":
            return """
             \(e)\(e)\(e)
            \(e)
            \(e) \(e)\(e)
            \(e)   \(e)
             \(e)\(e)\(e)
            """
        case "H":
            return """
            \(e)     \(e)
            \(e)     \(e)
            \(e)\(e)\(e)
            \(e)     \(e)
            \(e)     \(e)
            """
        case "I":
            return """
            \(e)\(e)\(e)
                 \(e)
                 \(e)
                 \(e)
            \(e)\(e)\(e)
            """
        case "J":
            return """
             \(e)\(e)\(e)\(e)
                    \(e)
                    \(e)
            \(e)   \(e)
              \(e)\(e)
            """
        case "K":
            return """
            \(e)   \(e)
            \(e) \(e)
            \(e)
            \(e) \(e)
            \(e)   \(e)
            """
        case "L":
            return """
            \(e)
            \(e)
            \(e)
            \(e)
            \(e)\(e)\(e)
            """
        case "M":
            return """
            \(e)         \(e)
            \(e)\(e)\(e)\(e)
            \(e)  \(e)   \(e)
            \(e)          \(e)
            \(e)          \(e)
            """
        case "N":
            return """
              \(e)    \(e)
            \(e)\(e)  \(e)
            \(e) \(e) \(e)
            \(e)  \(e)\(e)
            \(e)    \(e)
            """
        case "O":
            return """
              \(e)\(e)\(e)
            \(e)         \(e)
            \(e)         \(e)
            \(e)         \(e)
              \(e)\(e)\(e)
            """
        case "P":
            return """
            \(e)\(e)\(e)
            \(e)      \(e)
            \(e)\(e)\(e)
            \(e)
            \(e)
            """
        case "Q":
            return """
             \(e)\(e)\(e)
            \(e)       \(e)
            \(e)       \(e)
            \(e)    \(e)\(e)
             \(e)\(e)\(e)\(e)
                               \(e)
            """
        case "R":
            return """
            \(e)\(e)\(e)
            \(e)      \(e)
            \(e)\(e)\(e)
            \(e)   \(e)
            \(e)     \(e)
            """
        case "S":
            return """
              \(e)\(e)\(e)
            \(e)
              \(e)\(e)\(e)
                        \(e)
             \(e)\(e)\(e)
            """
        case "T":
            return """
            \(e)\(e)\(e)
                 \(e)
                 \(e)
                 \(e)
                 \(e)
            """
        case "U":
            return """
            \(e)    \(e)
            \(e)    \(e)
            \(e)    \(e)
            \(e)    \(e)
              \(e)\(e)
            """
        case "V":
            return """
            \(e)      \(e)
             \(e)    \(e)
              \(e)  \(e)
               \(e)\(e)
                 \(e)
            """
        case "W":
            return """
            \(e)                \(e)
             \(e)              \(e)
              \(e)    \(e)   \(e)
               \(e)\(e)\(e)\(e)
                 \(e)     \(e)
            """
        case "X":
            return """
            \(e)    \(e)
             \(e) \(e)
                \(e)
             \(e) \(e)
            \(e)    \(e)
            """
        case "Y":
            return """
            \(e)      \(e)
              \(e)  \(e)
                 \(e)
                 \(e)
                 \(e)
            """
        case "Z":
            return """
            \(e)\(e)\(e)
                  \(e)
                \(e)
             \(e)
            \(e)\(e)\(e)
            """
        default:
            return "Pattern not available for this letter."
        }
    }
}

#Preview {
    EmojiTextView(isTabBarHidden: .constant(true), navigationPath: .constant(NavigationPath()))
}

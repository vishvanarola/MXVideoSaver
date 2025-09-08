//
//  TextFieldView.swift
//  MXVideoSaver
//
//  Created by Vishva on 08/09/25.
//

import SwiftUI

struct TextFieldView: View {
    let headerTitle: String
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    var isEmoji: Bool = false
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(headerTitle)
                .font(FontConstants.MontserratFonts.medium(size: 15))
                .foregroundStyle(.black)
            
            TextField("", text: $text, prompt: Text(placeholder)
                .font(FontConstants.MontserratFonts.medium(size: 16))
                .foregroundColor(.gray)
            )
            .font(FontConstants.MontserratFonts.medium(size: 16))
            .keyboardType(keyboardType)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(pinkThemeColor, lineWidth: 1)
            )
            .background(pinkThemeColor.opacity(0.05))
            .onChange(of: text) { oldValue, newValue in
                if isEmoji {
                    let filtered = newValue.filter { $0.isEmoji }
                    if filtered != newValue {
                        text = filtered
                    }
                }
            }
        }
    }
}

extension Character {
    var isEmoji: Bool {
        return unicodeScalars.first?.properties.isEmojiPresentation == true ||
               unicodeScalars.contains { $0.properties.isEmoji }
    }
}

#Preview {
    TextFieldView(headerTitle: "Enter Text", placeholder: "Enter text here..", text: .constant("Enter Text"))
}

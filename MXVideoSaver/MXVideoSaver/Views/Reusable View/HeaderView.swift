//
//  HeaderView.swift
//  MXVideoSaver
//
//  Created by Vishva on 05/09/25.
//

import SwiftUI

struct HeaderView: View {
    let leftButtonImageName: String
    let rightButtonImageName: String?
    let headerTitle: String
    let leftButtonAction: () -> Void
    let rightButtonAction: (() -> Void)?
    
    var body: some View {
        ZStack {
            redThemeColor
            VStack {
                Spacer()
                HStack {
                    Button {
                        leftButtonAction()
                    } label: {
                        Image(leftButtonImageName)
                            .resizable()
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                    }
                    Spacer()
                    if (rightButtonImageName == nil) {
                        Spacer()
                    }
                    Text(headerTitle)
                        .font(FontConstants.SyneFonts.semiBold(size: 23))
                        .foregroundStyle(Color.white)
                    Spacer()
                    if let rightImage = rightButtonImageName {
                        Button {
                            rightButtonAction?()
                        } label: {
                            Image(rightImage)
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                        }
                    } else {
                        Spacer()
                        Spacer()
                    }
                }
                .padding(.bottom, 20)
                .padding(.horizontal, 20)
            }
        }
        .frame(height: UIScreen.main.bounds.height * 0.15)
    }
}

#Preview {
    HeaderView(
        leftButtonImageName: "ic_back",
        rightButtonImageName: nil,
        headerTitle: "Text Repeater",
        leftButtonAction: {
            print("Back button tapped")
        },
        rightButtonAction: nil
    )
}

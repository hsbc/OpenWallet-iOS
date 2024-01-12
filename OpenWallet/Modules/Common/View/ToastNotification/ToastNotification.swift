//
//  AlertNotification.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 9/7/22.
//

import SwiftUI

enum ToastType {
    case Warning
    case Error
}

struct ToastNotification: View {
    @Binding var showToast: Bool
    @Binding var message: String
    @State var duration = 2 // display durance in seconds. [weihao.zhang]
    @State var toastType: ToastType = ToastType.Warning
    
    private let errorForegroundColor: Color = Color.white
    private let errorBackgroundColor: Color = Color("#a8000b")
    private let errorBorderColor: Color = Color.clear
    private let errorImageName = "Error on light"
    
    private let warningForegroundColor: Color = Color.black
    private let warningBackgroundColor: Color = Color("#fff8ea")
    private let warningBorderColor: Color = Color("#ffbb33").opacity(0.7)
    private let warningImageName = "Warning on light"
    
    var body: some View {
        if showToast {
            VStack(alignment: .leading) {
                HStack(alignment: .top, spacing: 0) {
                    getImage()
                        .padding(.trailing, UIScreen.screenWidth * 0.032)
                    
                    Text(message)
                        .font(Font.custom("SFProText-Regular", size: FontSize.warning))
                        .foregroundColor(getForegroundColor())
                    
                    Spacer()
                }
                .padding(.horizontal, UIScreen.screenWidth * 0.043)
                .padding(.vertical, 10)
            }
            .frame(
                minWidth: UIScreen.screenWidth * 0.5,
                idealWidth: UIScreen.screenWidth,
                maxWidth: UIScreen.screenWidth,
                minHeight: UIScreen.screenHeight * 0.054,
                idealHeight: UIScreen.screenHeight * 0.054
            )
            .background(getBackgroundColor())
            .border(getBorderColor(), width: 1)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(duration)) {
                    showToast = false
                }
            }
        }
    }
}

extension ToastNotification {
    func getImage() -> some View {
        switch toastType {
        case ToastType.Warning:
            return AnyView(getWarningImage())
        case ToastType.Error:
            return AnyView(getErrorImage())
        }
    }
    
    func getWarningImage() -> some View {
        Image(warningImageName)
            .resizable()
            .background(Color.black)
            .clipShape(Circle())
            .scaledToFit()
            .frame(width: UIScreen.screenWidth * 0.053)
    }
    
    func getErrorImage() -> some View {
        Image(errorImageName)
            .resizable()
            .renderingMode(.template)
            .foregroundColor(.white)
            .scaledToFit()
            .frame(width: UIScreen.screenWidth * 0.053)
    }
    
    func getBackgroundColor() -> Color {
        switch toastType {
        case ToastType.Warning:
            return warningBackgroundColor
        case ToastType.Error:
            return errorBackgroundColor
        }
    }
    
    func getForegroundColor() -> Color {
        switch toastType {
        case ToastType.Warning:
            return warningForegroundColor
        case ToastType.Error:
            return errorForegroundColor
        }
    }
    
    func getBorderColor() -> Color {
        switch toastType {
        case ToastType.Warning:
            return warningBorderColor
        case ToastType.Error:
            return errorBorderColor
        }
    }
}

struct ToastNotification_Previews: PreviewProvider {
    @State static var show: Bool = true
    @State static var message: String = "Sorry, something is wrong. Please try again."
    
    static var previews: some View {
        VStack {
            ToastNotification(showToast: $show, message: $message)
                .padding(.horizontal, 10)
            
            ToastNotification(showToast: $show, message: $message, toastType: ToastType.Error)
                .padding(.horizontal, 10)
        }
    }
}

//
//  DeleteProfileView.swift
//  OpenWallet
//
//  Created by LuoYao on 2022/10/20.
//

import SwiftUI

struct DeleteProfileView: View {
    @Environment(\.dismiss) var dismiss
    @State private var isLoading: Bool = false
    @State private var showPopUp: Bool = false
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        ZStack {
            DeleteProfilePopUpView(settings: viewModel.deleteProfilePopupSettings, show: $showPopUp, yesButtonAction: {
                Task {
                    isLoading = true
                    await viewModel.deleteProfileRequest()
                    isLoading = false
                }
                
            }, noButtonAction: {
                showPopUp = false
            }
            ).zIndex(1)
            
            VStack {
                TopBarView(title: "Delete profile", backAction: {dismiss()})
                VStack(alignment: .leading, spacing: UIScreen.screenHeight * 0.02) {
                    Text("Do you wish to delete your OpenWallet Open profile?")
                        .font(Font.custom("SFProText-Medium", size: FontSize.button))
                    
                    Text("If so, you will no longer have access to this OpenWallet Open profile nor be allowed to register a new profile with the email address and mobile phone number connected to your bank account.\n\nThere is a processing time and OpenWallet Open will continue hosting your account data until the completion of the delete profile procedure, due to the OpenWallet customer service policy.")
                        .font(Font.custom("SFProText-Light", size: FontSize.body))
                }
                .padding(.top, UIScreen.screenHeight * 0.03)
                Spacer()
                ActionButton(text: "Delete my profile", isLoading: $isLoading) {
                    showPopUp = true
                }
                
                ActionButton(text: "Cancel", isPrimaryButton: false) {
                    dismiss()
                }
                
            }
            .viewAppearLogger(self)
            .padding([.leading, .trailing], PaddingConstant.widthPadding16)
            .padding(.bottom, PaddingConstant.heightPadding16)
            navigationLinks()
        }
    }
    func navigationLinks() -> some View {
        Group {
            NavigationLink(
                destination: SuccessView(mainHeadText: "Thank you for joining OpenWallet on this Gold X NFT journey.", detailInfo: "Your profile has been deleted.", buttonText: "Got it") {
                    WelcomeView().modifier(HideNavigationBar())
                }.modifier(HideNavigationBar()),
                isActive: $viewModel.deleteProfileSuccess
            ) {
                EmptyView()
            }
            
            NavigationLink(
                destination: ErrorView(errorMessage: "Sorry, something went wrong.") {
                    VStack(spacing: 7) {
                        ActionButton(text: "Try again") {
                            viewModel.navigateToErrorView = false
                        }
                        NavigationLink(
                            destination: MainView().modifier(HideNavigationBar()),
                            isActive: $viewModel.navigateToHomePage
                        ) {
                            EmptyView()
                        }
                        .accessibilityHidden(true)
                        ActionButton(text: "Go back to home", isPrimaryButton: false) {
                            AppState.shared.selectedTab = .home
                            viewModel.navigateToHomePage = true
                        }
                    }
                }.modifier(HideNavigationBar()),
                isActive: $viewModel.navigateToErrorView
            ) {
                EmptyView()
            }
            .accessibilityHidden(true)
            
        }
    }
    
}

struct DeleteProfileView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteProfileView(viewModel: ProfileViewModel())
    }
}

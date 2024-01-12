//
//  ChangePasswordView.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 7/26/22.
//

import SwiftUI

struct ChangePasswordView: View {
    @Environment(\.dismiss) var dismiss
    
    @State var scenario: ChangePasswordScenario = ChangePasswordScenario.changePassword
    @State var captchaScenario: CaptchaScenarioEnum = .changePassword
    @StateObject private var viewModel: PasswordViewModel = PasswordViewModel()
    
    @State private var showHelp: Bool = false
    @State private var navigateToMainView: Bool = false
    @State private var navigateToForgetPasswordRoot: Bool = false

    @FocusState private var isPasswordInputFieldFocused: Bool
    
    @Binding var showChangePasswordView: Bool
    
    var body: some View {
        mainContent()
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .overlay {
                BottomPopup(show: $viewModel.showPasswordRule, title: "Password rule", content: viewModel.passwordTips)
            }
            .viewAppearLogger(self)
    }
}

extension ChangePasswordView {
    func mainContent() -> some View {
        VStack {
            TopBarView(title: viewModel.getBarTitle(scenario), backAction: { dismiss() })
                .overlay(alignment: .trailing) {
                    Button {
                        showChangePasswordView = false
                    } label: {
                        Text("Cancel")
                            .font(Font.custom("SFProText-Regular", size: FontSize.body))
                            .foregroundColor(.black)
                    }
                }
                .padding(.bottom, UIScreen.screenHeight * 0.015)
            
            stepInfo()
                .padding(.bottom, UIScreen.screenHeight * 0.03)
            
            currentPasswordInput()
                .padding(.bottom, viewModel.isInvalidCurrentPassword ? UIScreen.screenHeight * 0.01 : UIScreen.screenHeight * 0.015)
            
            forgotPasswordSection()
                .frame(height: 48)
            
            Spacer()
            
            ActionButton(text: "Next",
                         isLoading: $viewModel.isLoggingOn,
                         isDisabled: $viewModel.disableLogOnButton) {
                Task {
                    await viewModel.changPasswordFirstFactor()
                }
            }
            .padding(.bottom, UIScreen.screenHeight * 0.02)
            
            navigationLinks()
        }
        .padding(.horizontal, UIScreen.screenWidth * 0.043)
    }
    
    func navigationLinks() -> some View {
        Group {
            NavigationLink(
                destination: ChangePasswordSelectVerificationView(
                    viewModel: viewModel,
                    navigateToWorkflowRoot: $showChangePasswordView,
                    showChangePasswordView: $showChangePasswordView
                ).modifier(HideNavigationBar()),
                isActive: $viewModel.navigateToVerificationStep
            ) {
                EmptyView()
            }
            .isDetailLink(false)
            .accessibilityHidden(true)

            NavigationLink(
                destination: ErrorView {
                    VStack(spacing: 7) {
                        ActionButton(text: "Try again") {
                            viewModel.navigateToErrorPage = false
                        }
                        
                        ActionButton(text: "Go back to home", isPrimaryButton: false) {
                            AppState.shared.selectedTab = .home
                            showChangePasswordView = false
                        }
                    }
                }.modifier(HideNavigationBar()),
                isActive: $viewModel.navigateToErrorPage
            ) {
                EmptyView()
            }
            .isDetailLink(false)
            .accessibilityHidden(true)
        }
    }
    
    func stepInfo() -> some View {
        VStack {
            HStack {
                Text("Step 1 of 3")
                    .font(Font.custom("SFProText-Medium", size: FontSize.callout))
                Text("Enter current password")
                    .font(Font.custom("SFProText-Regular", size: FontSize.callout))
                Spacer()
            }
            ProgressView(value: 1, total: 3)
                .progressViewStyle(LinearProgressViewStyle(tint: Color("#db0011")))
        }
    }
    
    func currentPasswordInput() -> some View {
        VStack(alignment: .leading, spacing: UIScreen.screenHeight * 0.005) {
            HStack(spacing: UIScreen.screenWidth * 0.011) {
                Text("Enter current password")
                    .font(Font.custom("SFProText-Regular", size: FontSize.label))

                Button {
                    isPasswordInputFieldFocused = false
                    viewModel.showPasswordRule.toggle()
                } label: {
                    Image(systemName: "questionmark.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16)
                        .foregroundColor(Color("#333333"))
                }
                .frame(width: 24, height: 24, alignment: .center)
                .contentShape(Rectangle())
                .accessibilityLabel("Click to get more tips about password")
                
                Spacer()
            }

            SecureTextField(
                inputText: $viewModel.currentPassword,
                isTextVisable: $viewModel.showCurrentPassword,
                isErrorState: $viewModel.isInvalidCurrentPassword,
                isFocused: _isPasswordInputFieldFocused
            )
            .onChange(of: viewModel.currentPassword, perform: { _ in
                viewModel.disableLogOnButton = !viewModel.currentPassword.isPasswordFullfilledLengthRequirement
                
                // Reset isInvalidPassword to false if the user is typing a new value. [weihao.zhang]
                viewModel.isInvalidCurrentPassword = false
            })
            
            if viewModel.isInvalidCurrentPassword {
                HStack {
                    Image("Error on light")
                        .resizable()
                        .scaledToFit()
                        .frame(width: UIScreen.screenWidth * 0.053)
                        .foregroundColor(Color("#a8000b"))

                    Text(viewModel.passwordErrorMessage)
                        .font(Font.custom("SFProText-Regular", size: FontSize.warning))
                }
                .padding(.top, UIScreen.screenHeight * 0.013)
            }
        }
    }
    
    func forgotPasswordSection() -> some View {
        NavigationLink {
            ResetPasswordEmailVerificationView(navigateToWorkflowRoot: $navigateToForgetPasswordRoot, showChangePasswordView: $showChangePasswordView).modifier(HideNavigationBar())
        } label: {
            Text("Forgot your password?")
                .font(Font.custom("SFProText-Medium", size: FontSize.body))
                .foregroundColor(Color("#333333"))
        }
        .id(navigateToForgetPasswordRoot)
        .accessibilityHint("Click to find your password.")
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView(showChangePasswordView: .constant(false))
    }
}

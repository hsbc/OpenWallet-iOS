//
//  RegisterPassword.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/9/9.
//

import SwiftUI

struct RegisterPassword: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: RegisterViewModel
    @FocusState private var isPasswordFieldFocused: Bool
    @FocusState private var isConfirmPasswordFieldFocused: Bool
    @State var isLoading: Bool = false
    @State private var passwordTips: Bool = false
    @State private var navigate: Bool = false
    @State private var diableNextButton: Bool = true
    
    var body: some View {
        ZStack {
            PopUpView(settings: viewModel.popupSettings, show: $viewModel.showPopup) {
                NavigationStateForRegister.shared.registerToRoot = false
            }.zIndex(1)
            
            VStack {
                NavigationLink(destination: RegisterEmail(viewModel: viewModel)
                    .navigationBarHidden(true), isActive: $navigate) {
                        EmptyView()
                    }.isDetailLink(false)
                
                TopBarView(title: "Register", backAction: {dismiss()})
                    .overlay(alignment: .trailing) {
                        Button {
                            NavigationStateForRegister.shared.registerToRoot = false
                        } label: {
                            Text("Cancel")
                                .font(Font.custom("SFProText-Regular", size: FontSize.body))
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.top, UIScreen.screenHeight*0.0136)
                
                VStack(alignment: .leading) {
                    ProgressBar(step: 2)
                    Group {
                        VStack {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack(alignment: .bottom, spacing: 0) {
                                    Text("Enter password")
                                        .font(Font.custom("SFProText-Regular", size: FontSize.callout))
                                        .padding(.top, UIScreen.screenHeight*0.0299)
                                    
                                    Button {
                                        passwordTips = true
                                        isPasswordFieldFocused = false
                                        isConfirmPasswordFieldFocused = false
                                    } label: {
                                        Image(systemName: "questionmark.circle")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 16)
                                            .foregroundColor(Color("#333333"))
                                    }
                                    .frame(width: 24, height: 24, alignment: .bottom)
                                    .contentShape(Rectangle())
                                    .accessibilityLabel("Click to get more tips about password")
                                }
                                
                                SecureTextField(
                                    inputText: $viewModel.password,
                                    isTextVisable: $viewModel.showPassword,
                                    isErrorState: $viewModel.isInvalidPassword,
                                    hideVisibleToggler: false
                                )
                                .focused($isPasswordFieldFocused)
                                .onChange(of: isPasswordFieldFocused) { isFocused in
                                    guard !viewModel.password.isEmpty && !isFocused else { return }
                                    viewModel.showPasswordTips = !viewModel.password.isAcceptablePassword
                                    viewModel.isInvalidPassword = !viewModel.password.isAcceptablePassword
                                }
                                .onChange(of: viewModel.password) { _ in
                                    viewModel.showPasswordTips = false
                                    viewModel.isInvalidPassword = false
                                }
                            }
                            
                            if viewModel.showPasswordTips {
                                HStack(alignment: .top) {
                                    Image("Warning on light")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 16, height: 16)
                                        .foregroundColor(Color("#305a85"))
                                        .padding(.trailing, 12)
                                    
                                    Text(viewModel.passwordTips)
                                        .font(Font.custom("SFProText-Regular", size: FontSize.warning))
                                        .frame(width: UIScreen.screenWidth*0.829, alignment: .top)
                                    
                                    Spacer()
                                }
                                .padding([.top, .bottom], 12)
                            }
                        }
                        .padding(.bottom, PaddingConstant.heightPadding16)
                        
                        VStack(alignment: .leading) {
                            SecureTextField(
                                label: "Confirm password",
                                inputText: $viewModel.confirmPassword,
                                isTextVisable: $viewModel.showConfirmPassword,
                                isErrorState: $viewModel.isInvalidConfirmPassword
                            )
                            .focused($isConfirmPasswordFieldFocused)
                            .onChange(of: isConfirmPasswordFieldFocused) { isFocused in
                                guard !viewModel.confirmPassword.isEmpty && !isFocused else { return }
                                diableNextButton = !viewModel.confirmPassword.isLengthMatch(min: 8, max: 20)
                                _ = viewModel.isConfirmPasswordFormatCorrectAndSameAsPassword()
                            }
                            .onChange(of: viewModel.confirmPassword) { _ in
                                diableNextButton = !viewModel.confirmPassword.isLengthMatch(min: 8, max: 20)
                                viewModel.isInvalidConfirmPassword = false
                                viewModel.showPasswordConfirmationError = false
                            }
                            
                            if viewModel.showPasswordConfirmationError {
                                HStack {
                                    Image("Error on light")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: UIScreen.main.bounds.width*0.053)
                                        .foregroundColor(Color("#a8000b"))
                                    
                                    Text("Password confirmation doesn't match.").font(Font.custom("SFProText-Regular", size: FontSize.warning))
                                    
                                    Spacer()
                                }
                                .padding([.top, .bottom], 12)
                            }
                        }
                        
                        if viewModel.showPasswordApiError {
                            HStack {
                                Image("Error on light")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: UIScreen.main.bounds.width*0.053)
                                    .foregroundColor(Color("#a8000b"))
                                
                                Text(viewModel.registerFlowApiErrorMessage)
                                    .font(Font.custom("SFProText-Regular", size: FontSize.warning))
                                
                                Spacer()
                            }
                            .padding(.top, UIScreen.screenHeight*0.016)
                        }
                    }
                    
                    Spacer()
                    
                    ActionButton(text: "Next", isLoading: $isLoading, isDisabled: $diableNextButton) {
                        Task {
                            if viewModel.isConfirmPasswordFormatCorrectAndSameAsPassword() {
                                isLoading = true
                                await viewModel.registerPassword()
                                if !viewModel.showPasswordApiError {
                                    navigate = true
                                }
                                isLoading = false
                            }
                        }
                        
                    }
                    .padding(.bottom, PaddingConstant.heightPadding16)
                    
                }
            }.padding(.horizontal, PaddingConstant.widthPadding16)
                .ignoresSafeArea(.keyboard, edges: .bottom)
                .viewAppearLogger(self)
            
            BottomPopup(show: $passwordTips, title: "Password rule", content: "Password must be 8-20 characters, includes at least three of the four types: upper/lower letters, number or symbols.")
        }
        .onAppear {
            // Reset status
            viewModel.showPassword = false
            viewModel.showConfirmPassword = false
        }
    }
}

struct RegisterPassword_Previews: PreviewProvider {
    static var previews: some View {
        RegisterPassword(viewModel: RegisterViewModel())
    }
}

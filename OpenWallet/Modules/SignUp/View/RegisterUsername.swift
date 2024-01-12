//
//  RegisterUsername.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/9/9.
//

import SwiftUI

struct RegisterUsername: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel = RegisterViewModel()
    @State private var usernameTips: Bool = false
    @State var isLoading: Bool = false
    @FocusState var isUsernameInputBoxFocused: Bool
    @State private var navigate: Bool = false
    @State private var diableNextButton: Bool = true
    
    var body: some View {
        ZStack {
            PopUpView(settings: viewModel.popupSettings, show: $viewModel.showPopup) {
                NavigationStateForRegister.shared.registerToRoot = false
            }.zIndex(1)
            
            VStack {
                NavigationLink(destination: RegisterPassword(viewModel: viewModel)
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
                    ProgressBar(step: 1)
                    // email
                    HStack(alignment: .bottom, spacing: 0) {
                        Text("Enter your username")
                            .font(Font.custom("SFProText-Regular", size: FontSize.label))
                            .foregroundColor(Color("#333333"))
                            .padding(.top, UIScreen.screenHeight*0.0299)
                        
                        Button {
                            usernameTips = true
                            isUsernameInputBoxFocused = false
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
                    
                    InputTextField(inputText: $viewModel.username, isErrorState: $viewModel.showUsernameAcceptanceCriteriaInfo, isFocused: _isUsernameInputBoxFocused, onTextChange: { inputUsername in
                        diableNextButton = !inputUsername.isLengthMatch(min: 6, max: 30)
                        viewModel.showUsernameAcceptanceCriteriaInfo = false
                        
                    }, onFocusChange: { isOnFocus in
                        guard !isOnFocus else { return }
                        
                    })
                    
                    if viewModel.showUsernameAcceptanceCriteriaInfo {
                        HStack(alignment: .top) {
                            Image("Warning on light")
                                .resizable()
                                .scaledToFit()
                                .frame(width: UIScreen.main.bounds.width*0.053)
                                .foregroundColor(Color("#a8000b"))
                            
                            Text("The username must be 6-30 characters long and include a combination of lower and upper case letters. Numbers and underscore are also permitted but not required.")
                                .font(Font.custom("SFProText-Regular", size: FontSize.warning))
                            
                            Spacer()
                        }
                        .padding(.top, UIScreen.screenHeight*0.016)
                    }
                    
                    if viewModel.showUsernameApiError {
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
                    isLoading = true
                    isUsernameInputBoxFocused = false
                    guard viewModel.username.isAcceptableUsername else {
                        viewModel.showUsernameAcceptanceCriteriaInfo = true
                        isLoading = false
                        return
                    }
                    viewModel.showUsernameAcceptanceCriteriaInfo = false
                    Task {
                        await viewModel.registerUsername()
                        isLoading = false
                        if !viewModel.showUsernameApiError {
                            navigate = true
                        }
                        
                        _ = await User.shared.fetchCountryCode()
                    }
                }
                .padding(.bottom, PaddingConstant.heightPadding16)
            }
            .padding(.horizontal, PaddingConstant.widthPadding16)
            .viewAppearLogger(self)
            
            BottomPopup(show: $usernameTips, title: "Create a username", content: "The username must be 6-30 characters long and include a combination of lower and upper case letters. Numbers and underscore are also permitted but not required.")
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

struct RegisterUsername_Previews: PreviewProvider {
    static var previews: some View {
        RegisterUsername()
    }
}

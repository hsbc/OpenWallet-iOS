//
//  HelpCenterView.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 8/31/22.
//

import SwiftUI

struct HelpCenterView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var feedback: String = ""
    @State private var disableSubmit: Bool = true
    
    @FocusState private var onTextEditorFocused: Bool
    
    @State private var isLoading: Bool = false
    @State private var navigateToErrorPage: Bool = false
    
    @State private var showAlert: Bool = false
    @State private var addFeedbackErrorMessage: String = AppState.defaultErrorMesssage
    
    private let feedbackLengthLimit: Int = 2000

    private let feedbackService: FeedbackService = FeedbackService()

    var body: some View {
        VStack(spacing: 0) {
            TopBarView(title: "Help center", backAction: {dismiss()})
            
            VStack(alignment: .leading, spacing: UIScreen.screenHeight * 0.026) {
                contactUsSection()
                feedbackSection()
            }
            .padding(.top, UIScreen.screenHeight * 0.044)
            .overlay(alignment: .top) {
                ToastNotification(showToast: $showAlert, message: $addFeedbackErrorMessage)
            }
            
            NavigationLink(
                destination: ErrorView {
                    VStack(spacing: 7) {
                        ActionButton(text: "Try again") {
                            navigateToErrorPage = false
                        }

                        ActionButton(text: "Go back to home", isPrimaryButton: false) {
                            AppState.shared.selectedTab = .home
                            NavigationStateForProfile.shared.backToProfile = true
                        }
                    }
                }.modifier(HideNavigationBar()),
                isActive: $navigateToErrorPage
            ) {
                EmptyView()
            }
            .accessibilityHidden(true)
            
            Spacer()
        }
        .onTapGesture {
            onTextEditorFocused = false
        }
        .padding(.horizontal, UIScreen.screenWidth * 0.044)
    }
}

extension HelpCenterView {
    func contactUsSection() -> some View {
        VStack(alignment: .leading, spacing: UIScreen.screenHeight * 0.01) {
            Text("Contact Us")
                .font(Font.custom("SFProText-Medium", size: FontSize.label))
            
            Text("Have a question? A suggestion? Or would like to share any comments, about our App or service? You can write them here.")
                .font(Font.custom("SFProText-Light", size: FontSize.body))
        }
    }
    
    func feedbackSection() -> some View {
        VStack(alignment: .leading, spacing: UIScreen.screenHeight * 0.01) {
            Text("We appreciate your feedback.")
                .font(Font.custom("SFProText-Regular", size: FontSize.label))

            TextEditor(text: $feedback)
                .limitInputLength(value: $feedback, length: feedbackLengthLimit)
                .textInputAutocapitalization(.never)
                .font(Font.custom("SFProText-Light", size: FontSize.body))
                .multilineTextAlignment(.leading)
                .padding(.horizontal, UIScreen.screenWidth * 0.043)
                .padding(.vertical, UIScreen.screenHeight * 0.015)
                .frame(width: UIScreen.screenWidth * 0.915, height: UIScreen.screenHeight * 0.346)
                .border(.black, width: 1)
                .focused($onTextEditorFocused)
                .onChange(of: feedback, perform: { newValue in
                    disableSubmit = newValue.isEmpty || newValue.count > feedbackLengthLimit
                })
                .overlay(alignment: .topLeading) {
                    let showTextEditorPlaceHolder: Bool = !onTextEditorFocused && feedback.isEmpty
                    if showTextEditorPlaceHolder {
                        Text("Your feedback")
                            .font(Font.custom("SFProText-Light", size: FontSize.body))
                            .padding()
                    }
                }

            HStack {
                Spacer()
                Text("\(feedback.count)/\(feedbackLengthLimit)")
                    .font(Font.custom("SFProText-Regular", size: FontSize.caption))
            }
            
            Spacer()
            
            ActionButton(text: "Submit", isLoading: $isLoading, isDisabled: $disableSubmit) {
                guard !feedback.isEmpty else { return }
                
                Task { @MainActor in
                    do {
                        isLoading = true
                        let response = try await feedbackService.sendFeedback(feedback, User.shared.token)
                        let isSuccess = response.status
                        
                        isLoading = false

                        if isSuccess {
                            dismiss()
                        } else {
                            prepareErrorToast()
                        }
                    } catch _ as ApiErrorResponse {
                        isLoading = false
                        prepareErrorToast()
                    } catch {
                        isLoading = false
                        navigateToErrorPage = true
                    }
                }
            }
            
            ActionButton(text: "Cancel", isPrimaryButton: false) {
                dismiss()
            }
        }
    }
    
    func prepareErrorToast(_ errorMesssage: String? = nil) {
        showAlert = true
        addFeedbackErrorMessage = errorMesssage ?? AppState.defaultErrorMesssage
    }
    
}

struct HelpCenterView_Previews: PreviewProvider {
    static var previews: some View {
        HelpCenterView()
    }
}

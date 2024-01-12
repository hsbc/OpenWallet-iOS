//
//  RegisterTermsAndConditions.swift
//  OpenWallet
//
//  Created by LuoYao on 2022/10/9.
//

import SwiftUI

struct RegisterTermsAndConditions: View {
    @Environment(\.dismiss) private var dismiss
    @State var isLoadingTermsAndConditions: Bool = false
    @State var termsAndConditions: TnC = TnC(id: -1, content: "", language: "", region: "", category: TnCCategory.registration, filePath: "", fileName: "", createTime: "", updateTime: "")
    
    @ObservedObject var viewModel: RegisterViewModel
    @State var isTermsAndConditionsAccepted: Bool = false
    @State var isRegisterSuccess: Bool = false
    
    @State private var showAlert: Bool = false
    @State private var failedToLoadTnC: Bool = false
    @State private var failedToLoadTnCErrorMessage: String = AppState.defaultErrorMesssage
    @State private var navigateToErrorPage: Bool = false
    
    private let tncService: TnCService = TnCService()
    
    private let tncAgreeCheckboxMessage: String = "I agree to all the terms and conditions (T&Cs) and understand a copy of these T&Cs will be sent to my email address."

    var body: some View {
        ZStack {
            PopUpView(settings: viewModel.popupSettings, show: $viewModel.showPopup) {
                NavigationStateForRegister.shared.registerToRoot = false
            }.zIndex(1)
            
            VStack(spacing: 0) {
                TopBarView(title: "Terms and conditions", backAction: {
                    // A workaround to hide SMS OTP verification in previous step. [weihao.zhang]
                    viewModel.showSMSOTPVerification = false

                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        dismiss()
                    }
                })
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
                    .padding(.horizontal, PaddingConstant.widthPadding16)
                
                VStack(spacing: 0) {
                    if isLoadingTermsAndConditions {
                        LoadingIndicator()
                    } else if failedToLoadTnC {
                        tncApiErrorView()
                    } else {
                        tncContent()
                    }
                }
                .padding(.top, UIScreen.screenHeight * 0.017)
                .overlay(alignment: .top) {
                    ToastNotification(showToast: $showAlert, message: $failedToLoadTnCErrorMessage)
                        .padding(.horizontal, PaddingConstant.widthPadding16)
                }

                navigationLinks()
            }
            .padding(.bottom, 10)
            .viewAppearLogger(self)
            .task {
                await getTermsAndConditions()
            }
        }
    }

}

extension RegisterTermsAndConditions {
    
    func tncContent() -> some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    Text(termsAndConditions.content)
                        .font(Font.custom("SFProText-Regular", size: FontSize.body))
                        .padding(.horizontal, PaddingConstant.widthPadding16)
                    
                    Spacer()
                    
                    Divider().padding(.vertical, UIScreen.screenHeight*0.02)

                    HStack(alignment: .top, spacing: 6.33) {
                        Image(systemName: isTermsAndConditionsAccepted ? "checkmark.circle.fill" : "circle")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(isTermsAndConditionsAccepted ? Color("#00847f") : .black)
                        Text(tncAgreeCheckboxMessage)
                            .font(Font.custom("SFProText-Regular", size: FontSize.info))
                        Spacer()
                    }
                    .padding(.horizontal, PaddingConstant.widthPadding16)
                    .onTapGesture {
                        isTermsAndConditionsAccepted.toggle()
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityHint("Click to accept terms and conditions")

                    ActionButton(
                        text: "Continue",
                        isLoading: $viewModel.isCallingTAndCApi,
                        isDisabled: Binding<Bool>(
                            get: { !isTermsAndConditionsAccepted },
                            set: { isTermsAndConditionsAccepted = !$0 }
                        )
                    ) {
                        Task {
                            isRegisterSuccess = await viewModel.registerUser()
                            navigateToErrorPage = !isRegisterSuccess
                        }
                    }
                    .padding(.top, UIScreen.screenHeight*0.02)
                    .padding(.horizontal, PaddingConstant.widthPadding16)
                    .disabled(!isTermsAndConditionsAccepted)
                    .accessibilityHint("Please accept terms and conditions to register your account.")
                }
                .frame(minHeight: geometry.size.height)
            }
        }
    }
    
    func navigationLinks() -> some View {
        Group {
            NavigationLink(
                destination: ErrorView(errorMessage: "One or more of the details you entered does not match the information on our records.") {
                    ActionButton(text: "Go back") {
                        NavigationStateForWelcome.shared.backToWelcome = UUID()
                    }
                }.modifier(HideNavigationBar()),
                isActive: $navigateToErrorPage
            ) {
                EmptyView()
            }
            .accessibilityHidden(true)
            
            NavigationLink(
                destination: SuccessView(detailInfo: "You have successfully registered.", buttonText: "Log on") {
                    LogonView().modifier(HideNavigationBar())
                }.modifier(HideNavigationBar()),
                isActive: $isRegisterSuccess
            ) {
                EmptyView()
            }
            .accessibilityHidden(true)
        }
    }
    
    func tncApiErrorView() -> some View {
        GeometryReader { geometry in
            List {
                SwipeDownToRefreshIndicator()
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
            .refreshable {
                await getTermsAndConditions()
            }
        }
    }
    
    private func getTermsAndConditions() async {
        do {
            isLoadingTermsAndConditions = true
            
            let response = try await tncService.getTncByCategoryAndLanguage(category: .registration, language: .english, secretToken: viewModel.secretToken)
            let getTnCSuccess: Bool = response.status
            
            isLoadingTermsAndConditions = false

            if getTnCSuccess {
                termsAndConditions = response.data!
            } else {
                failedToLoadTnC = true
                showAlert = true
                failedToLoadTnCErrorMessage = response.message
            }
        } catch let apiErrorResponse as ApiErrorResponse {
            OHLogInfo(apiErrorResponse)
            isLoadingTermsAndConditions = false
            failedToLoadTnC = true
            showAlert = true
            failedToLoadTnCErrorMessage = apiErrorResponse.message ?? AppState.defaultErrorMesssage
            navigateToErrorPage = true
        } catch {
            OHLogInfo(error)
            failedToLoadTnC = true
            navigateToErrorPage = true
            isLoadingTermsAndConditions = false
        }
    }

}

struct RegisterTermsAndConditions_Previews: PreviewProvider {
    static var previews: some View {
        RegisterTermsAndConditions(viewModel: RegisterViewModel())
    }
}

//
//  SecurityIdentityView.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 8/31/22.
//

import SwiftUI

struct SecurityIdentityView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var getSecurityIdentityImmediately: Bool = true
    
    @State private var accountLegalName: String = "N/A"
    @State private var isLoadingSecurityIdentity: Bool = false
    
    @State private var showFailedToLoadSecurityIdentityAlert: Bool = false
    @State private var failedToLoadSecurityIdentity: Bool = false
    @State private var failedToLoadSecurityIdentityMessage: String = AppState.defaultErrorMesssage
    
    @State private var navigateToHomePage: Bool = false
    @State private var navigateToErrorPage: Bool = false
    
    private let bankService: BankService = BankService()

    var body: some View {
        VStack(spacing: 0) {
            TopBarView(title: "Security digital identity", backAction: { dismiss() })
            
            VStack {
                if isLoadingSecurityIdentity {
                    LoadingIndicator()
                } else if failedToLoadSecurityIdentity {
                    failedToLoadSecurityIdentityView()
                } else {
                    securityIdentitySection()
                        .padding(.top, UIScreen.screenHeight * 0.024)
                    Spacer()
                }
            }
            .frame(maxWidth: UIScreen.screenWidth)
            .overlay(alignment: .top) {
                ToastNotification(showToast: $showFailedToLoadSecurityIdentityAlert, message: $failedToLoadSecurityIdentityMessage)
            }
            
            navigationLinks()
        }
        .viewAppearLogger(self)
        .padding(.horizontal, UIScreen.screenWidth * 0.043)
        .task {
            if getSecurityIdentityImmediately {
                await getAccountInfo()
            }
        }
    }
}

extension SecurityIdentityView {
    func securityIdentitySection() -> some View {
        VStack(spacing: UIScreen.screenHeight * 0.037) {
            VStack(alignment: .leading, spacing: UIScreen.screenHeight * 0.015) {
                HStack {
                    Text("OpenWallet Open account user")
                        .font(Font.custom("SFProText-Regular", size: FontSize.label))
                    Spacer()
                }
                
                Text(accountLegalName)
                    .font(Font.custom("SFProText-Medium", size: FontSize.body))
            }
            
            VStack(alignment: .leading, spacing: UIScreen.screenHeight * 0.015) {
                HStack {
                    Text("Email address")
                        .font(Font.custom("SFProText-Regular", size: FontSize.label))
                    Spacer()
                }
                
                Text(User.shared.email.isEmpty ? "N/A" : User.shared.email)
                    .font(Font.custom("SFProText-Medium", size: FontSize.body))
            }

            VStack(alignment: .leading, spacing: UIScreen.screenHeight * 0.015) {
                HStack {
                    Text("Mobile phone number")
                        .font(Font.custom("SFProText-Regular", size: FontSize.label))
                    Spacer()
                }
                
                Text(getPhoneNumber())
                    .font(Font.custom("SFProText-Medium", size: FontSize.body))
            }
        }
    }
    
    func failedToLoadSecurityIdentityView() -> some View {
        GeometryReader { geometry in
            List {
                SwipeDownToRefreshIndicator()
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
            .refreshable {
                await getAccountInfo()
            }
        }
    }
    
    func navigationLinks() -> some View {
        Group {
            NavigationLink(
                destination: ErrorView {
                    VStack(spacing: 7) {
                        ActionButton(text: "Try again") {
                            getSecurityIdentityImmediately = false
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
        }
    }
    
    func getPhoneNumber() -> String {
        guard !User.shared.phoneNumber.isEmpty && !User.shared.phoneCountryCode.isEmpty else {
            return "N/A"
        }
        
        return "+\(User.shared.phoneCountryCode) \(User.shared.phoneNumber)"
    }
    
    func getAccountInfo() async {
        guard User.shared.isLoggin else { return }
        
        do {
            if !isLoadingSecurityIdentity {
                isLoadingSecurityIdentity = true
            }

            let customerBankInfo = try await bankService.getBankInfo(User.shared.token)
            accountLegalName = customerBankInfo.legalName

            isLoadingSecurityIdentity = false
        } catch let apiErrorResponse as ApiErrorResponse {
            OHLogInfo(apiErrorResponse)
            failedToLoadSecurityIdentity = true
            failedToLoadSecurityIdentityMessage = apiErrorResponse.message ?? AppState.defaultErrorMesssage
            showFailedToLoadSecurityIdentityAlert = true
            isLoadingSecurityIdentity = false
        } catch {
            OHLogInfo(error)
            failedToLoadSecurityIdentity = true
            navigateToErrorPage = true
            isLoadingSecurityIdentity = false
        }
    }
    
}

struct SecurityIdentityView_Previews: PreviewProvider {
    static var previews: some View {
        SecurityIdentityView()
    }
}

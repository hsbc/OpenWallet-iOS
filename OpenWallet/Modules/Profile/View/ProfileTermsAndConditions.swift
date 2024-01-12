//
//  ProfileTermsAndConditions.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 9/12/22.
//

import SwiftUI

struct ProfileTermsAndConditions: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var getTnCImmediately: Bool = true
    @State var isLoadingTermsAndConditions: Bool = false
    @State var termsAndConditions: TnC = TnC(id: -1, content: "", language: "", region: "", category: TnCCategory.registration, filePath: "", fileName: "", createTime: "", updateTime: "")
    
    @State private var showAlert: Bool = false
    @State private var failedToLoadTnc: Bool = false
    @State private var failedToLoadTnCErrorMessage: String = ""
    
    @State private var navigateToErrorPage: Bool = false
    
    private let tncService: TnCService = TnCService()

    var body: some View {
        VStack(spacing: 0) {
            TopBarView(title: "Terms and conditions", backAction: {dismiss()})
                .padding(.horizontal, UIScreen.screenWidth * 0.043)

            VStack(spacing: 0) {
                if isLoadingTermsAndConditions {
                    LoadingIndicator()
                } else if failedToLoadTnc {
                    failedToLoadTNCConentView()
                } else {
                    tncContent()
                }
            }
            .padding(.top, UIScreen.screenHeight * 0.017)
            .overlay(alignment: .top) {
                ToastNotification(showToast: $showAlert, message: $failedToLoadTnCErrorMessage)
            }
            
            navigationLinks()
        }
        .task {
            if getTnCImmediately {
                await getTermsAndConditions()
            }
        }
    }

}

extension ProfileTermsAndConditions {
    
    func tncContent() -> some View {
        VStack(spacing: 0) {
            ScrollView {
                Text(termsAndConditions.content)
                    .font(Font.custom("SFProText-Regular", size: FontSize.body))
                    .padding(.horizontal, UIScreen.screenWidth * 0.043)
            }
            Spacer()
        }
    }

    func failedToLoadTNCConentView() -> some View {
        GeometryReader { geometry in
            List {
                SwipeDownToRefreshIndicator()
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
            .refreshable {
                OHLogInfo("Refresh tnc.")
                await getTermsAndConditions()
            }
        }
    }
    
    func navigationLinks() -> some View {
        Group {
            NavigationLink(
                destination: ErrorView {
                    VStack(spacing: 7) {
                        ActionButton(text: "Try again") {
                            getTnCImmediately = false
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
    
    private func getTermsAndConditions() async {
        do {
            isLoadingTermsAndConditions = true
            
            let response = try await tncService.getTncByCategoryAndLanguage(category: .registration, language: .english, userToken: User.shared.token)
            let getTnCSuccess: Bool = response.status

            if getTnCSuccess {
                termsAndConditions = response.data!
            } else {
                failedToLoadTnc = true
                showAlert = true
                failedToLoadTnCErrorMessage = response.message
            }
            
            isLoadingTermsAndConditions = false
        } catch let apiErrorResponse as ApiErrorResponse {
            OHLogInfo(apiErrorResponse)
            isLoadingTermsAndConditions = false
            failedToLoadTnc = true
            showAlert = true
            failedToLoadTnCErrorMessage = apiErrorResponse.message ?? AppState.defaultErrorMesssage
            isLoadingTermsAndConditions = false
        } catch {
            OHLogInfo(error)
            failedToLoadTnc = true
            navigateToErrorPage = true
            isLoadingTermsAndConditions = false
        }
    }

}

struct ProfileTermsAndConditions_Previews: PreviewProvider {
    
    static var agreementCoverage: String = "OpenWallet Open Registration 2022 Terms and Conditions\n\n1 .This Mid-Autumn Spend and Get Promotion 2022 (\"Promotion\") is valid from 17 June 2022 to 31 July 2022, both dates inclusive (\"Promotional Period\") unless otherwise stated, and is offered by OpenWallet Bank (Singapore) Limited (\"OpenWallet\" or the \"Bank\") to customers:\na.who hold one or more main OpenWallet credit cards (except OpenWallet corporate cards, and OpenWallet debit cards) issued by OpenWallet in Singapore (each, a \"Card\") as a credit cardholder; and\nb.whose Card account is in good standing with OpenWallet over the entire Promotional Period and at the time of fulfillment (as determined by OpenWallet at its discretion), (each such customer, a \"Cardholder\")\n\n2 .OpenWallet reserves the right to determine at our discretion whether:z\na.Cardholder(s) have met all the requirements of this Promotion; and\nb.Charges made to the Card qualify towards fulfilment of the relevant accumulated minimum Qualifying Spend (as defined below) set for the purposes of this Promotion.\n\n3 .For the purpose of this Promotion:\n\"Qualifying Spend\" shall mean posted retail transactions (including but not limited to monthly charges under the interest free instalment payment plan of any merchant, and in the case of OpenWallet Spend Instalment, only the total purchase amount will qualify as a Qualifying Spend in the month of purchase), including Local Retail Transactions, Online Transactions and Overseas Transactions, charged to a Registered Card (as defined below) account and/or to the account of the supplemental cardholder of the relevant Registered Cardholder (as defined below) during the Promotional Period BUT shall exclude the Excluded Transactions.\n\n\"Local Retail Transactions\" shall mean posted retail transactions (excluding Online Transactions) which are successfully carried out in Singapore dollars to a Registered Card account and/or to the account of the supplementary cardholder of the relevant Registered Cardholder.\n\n\"Online Transactions\" shall mean all retail transactions successfully charged to a Registered Card account and/or to the account of a supplemental cardholder of a Registered Cardholder made via the internet and processed by the respective merchants/acquirers as an online transaction type through the MasterCard International Incorporated and/or Visa Worldwide networks during the Promotional Period.\n\n\"Overseas Transactions\" shall mean all overseas transactions successfully carried out outside Singapore and charged in foreign currency to a Registered Card account and/or to the account of a supplemental cardholder of a Registered Cardholder during the Promotional Period.\n\n\"Excluded Transactions\" shall mean any of the following (which shall, where applicable, be determined based on the transaction descriptions reflected in OpenWallet's system and the merchant category codes from Visa / MasterCard):\n\t •Foreign exchange transactions (including but not limited to Forex.com);\n\t •Donations and payments to charitable, social organisations and religious organisations;\n\t •Quasi-cash transactions (including but not limited to transactions relating to money orders, traveler's checks, gaming related transactions, lottery tickets and gambling);\n\t •Payments made to financial institutions, securities brokerages or dealers (including but not limited to the trading of securities, investments or crypto-currencies of any kind);\n\t •Payments on money payments/transfers (including but not limited to Paypal, SKR skrill.com, CardUp, SmoovPay, iPayMy);\n\t •Payments to any professional services provider (including but not limited to GOOGLE Ads, Facebook Ads, Amazon Web Services, MEDIA TRAFFIC AGENCY INC);\n\t •Top-ups, money transfers or purchase of credits of prepaid cards, stored-value cards or e-wallets (including but not limited to Grab Top-Up, EZ-Link, Transitlink, NETS Flashpay and Youtrip);\n\t •Payments in connection with any government institutions and/or services (including but not limited to court costs, fines, bail and bond payment) other than (tuition fee payments) to the following educational institutions:\n\t\t•National University of Singapore (NUS);\n\t\t•Nanyang Technological University (NTU);\n\t\t•Singapore Management University (SMU);\n\t\t•Singapore University of Technology and Design (SUTD);\n\t\t•Singapore Institute of Technology (SIT) and Singapore University of Social Sciences (SUSS);\n\t\t•Singapore Polytechnic (SP);\n\t\t•Nanyang Polytechnic (NYP);\n\t\t•Ngee Ann Polytechnic;\n\t\t•Republic Polytechnic;\n\t\t•Temasek Polytechnic;\n\t•Any AXS and ATM transactions;\n\t•Any payments or transactions on Carousell;\n\t•Tax payments (including OpenWallet Tax Payment Facility);\n\t•Payments for cleaning, maintenance and janitorial services (including property management fees);\n\t•Payments on utilities;\n\t•The monthly instalment amounts under the OpenWallet Spend Instalment;\n\t•Balance transfers, fund transfers, cash advances, finance charges, late charges, OpenWallet's Cash Instalment Plan, any fees charged by OpenWallet; and\n\t•Any unposted, cancelled, disputed and refunded transactions, and such other categories of transactions which OpenWallet may exclude from time to time without notice or giving reasons.\n\n"
    
    static var tnc: TnC = TnC(id: -1, content: agreementCoverage, language: "", region: "", category: TnCCategory.registration, filePath: "", fileName: "", createTime: "", updateTime: "")
    
    static var previews: some View {
        ProfileTermsAndConditions(termsAndConditions: tnc)
    }
}

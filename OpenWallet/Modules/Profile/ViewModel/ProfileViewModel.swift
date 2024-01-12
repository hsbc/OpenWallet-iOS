//
//  ProfileViewModel.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 7/15/22.
//

import Foundation
import SwiftUI

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var preSignOutConfirmation: Bool = false
    
    @Published var showEditEmailView: Bool = false
    @Published var showChangePasswordView: Bool = false
    @Published var showLogOnReminder: Bool = false
    
    @Published var QACategories: [String] = [] // Note: use an array here to remember the order of FAQ categories here since Dictinaries has no order in keys. [weihao.zhang]
    @Published var QADict: [String: [QAModel]] = [:] // Note: Dictinaries in Swift are an unordered collection type. [weihao.zhang]
    @Published var QAResults: [QAModel] = []
    @Published var isFetchingFAQ: Bool = false
    @Published var failedToLoadFAQ: Bool = false
    @Published var showFailedToFetchFAQWarningNotification: Bool = false
    @Published var failedToFetchFAQWarningMessage: String = AppState.defaultErrorMesssage
    
    @Published var isLoggingOut: Bool = false
    
    // [deleteProfile/closeAccount feature use]
    @Published var deleteProfileSuccess: Bool = false
    @Published var showPopupAtVerifyView: Bool = false
    @Published var navigateToErrorView: Bool = false
    @Published var navigateToErrorViewFromFAQ: Bool = false
    @Published var navigateToHomePage: Bool = false    
    @Published var deleteProfilePopupSettings: DeleteProfilePopUpSettings =
    DeleteProfilePopUpSettings(
        title: "Confirm deleting your profile?",
        messages: ["If so, you will no longer have access to this OpenWallet Open profile nor be allowed to register a new profile with your current registered profile information."],
        YesButtonText: "Yes",
        NoButtonText: "No"
    )
    // [deleteProfile/closeAccount feature use] end

    let authService: AuthService
    let faqService: FaqService
    let customerService: CustomerService
    
    init(authService: AuthService = AuthService(), faqService: FaqService = FaqService(), customerService: CustomerService = CustomerService()) {
        self.authService = authService
        self.faqService = faqService
        self.customerService = customerService
    }
    
    func sortQA() async {// parameter is fetched from api
        guard User.shared.isLoggin else { return }
        
        do {
            isFetchingFAQ = true
            failedToLoadFAQ = false

            let result = try await faqService.getFaq(User.shared.token)
            guard result != nil else { return }
            QAResults = result!
            
            isFetchingFAQ = false
            
            for index in 0..<QAResults.count {
                let currentCategory = QAResults[index].category
                
                if self.QACategories.contains(currentCategory) {
                    var qaModelsForCategory = self.QADict[currentCategory]
                    qaModelsForCategory?.append(QAResults[index])
                    // add current question to related category
                    guard qaModelsForCategory != nil else { return }
                    self.QADict.updateValue(qaModelsForCategory!, forKey: currentCategory)
                } else {
                    self.QACategories.append(currentCategory)
                    // create category and add question to it
                    self.QADict[currentCategory] = [QAResults[index]]
                }
            }
        } catch let apiErrorResponse as ApiErrorResponse {
            OHLogInfo(apiErrorResponse)
            isFetchingFAQ = false
            failedToLoadFAQ = true
            showFailedToFetchFAQWarningNotification = true
            failedToFetchFAQWarningMessage = "\(apiErrorResponse.message ?? AppState.defaultErrorMesssage)"
        } catch {
            OHLogInfo(error)
            isFetchingFAQ = false
            failedToLoadFAQ = true
            navigateToErrorViewFromFAQ = true
        }
    }
    
    func clearFAQ() {
        QACategories = []
        QADict = [:]
    }
        
    func logOutUser() async {
        Task {
            guard User.shared.isLoggin else { return }
            _ = try await authService.logout(User.shared.token)
        }
    }
    
    func remindLogOn() {
        self.showLogOnReminder = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            self.showLogOnReminder = false
        }
    }
    
}

extension ProfileViewModel {
        
    func deleteProfileRequest() async {
        do {
            let (success, message) = try await customerService.tryModifyCustomerAccountStatus(username: User.shared.name, statusEnum: UserStatusEnum.closing, userToken: User.shared.token)
            if !success {
                navigateToErrorView = true
                deleteProfileSuccess = false
                if message.contains(ERRCODE_EXCEED_TIME_LIMIT) {
                    showPopupAtVerifyView = true
                }
            }
            deleteProfileSuccess = true
            
        } catch let apiErrorResponse as ApiErrorResponse {
            guard let message = apiErrorResponse.message else {
                deleteProfileSuccess = false
                navigateToErrorView = true
                return
            }
            if message.contains(ERRCODE_EXCEED_TIME_LIMIT) {
                showPopupAtVerifyView = true
            } else {
                navigateToErrorView = true
            }
            deleteProfileSuccess = false
        } catch {
            deleteProfileSuccess = false
            navigateToErrorView = true
        }
    }
    
}

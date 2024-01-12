//
//  EmailViewModel.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 8/1/22.
//

import Foundation

@MainActor
class EmailViewModel: ObservableObject {
    @Published var topBarTitle: String = "Change email"
    
    @Published var email: String = User.shared.email
    @Published var isEmailVerified: Bool = false
    
    @Published var newEmail: String = ""
    @Published var isNewEmailVerified: Bool = false
    
    @Published var captcha: String = ""
    @Published var isCaptchaReady: Bool = false
    @Published var newEmailCaptcha: String = ""

    // Navigation isActive controllers
    @Published var showEmailVerificationStep: Bool = false
    @Published var showNewEmailVerificationStep: Bool = false
    
    @Published var showNewEmailCheckError: Bool = false
    @Published var newEmailCheckErrorMessage: String = ""
    
    @Published var updateEmailSuccessfully: Bool = false
    @Published var failedToUpdateEmail: Bool = false
    @Published var updateEmailSuccessfullyMessage = "You email address has been successfully update."
    
    private let emailFormatNotCorrectMessage: String = "Error: Email format is not correct."
    
    let authService: AuthService

    init(authService: AuthService = AuthService()) {
        self.authService = authService
    }
    
    func checkEmail(_ email: String) {
        guard email.isEmail else {
            newEmailCheckErrorMessage = emailFormatNotCorrectMessage
            showNewEmailCheckError = true
            return
        }
        
        Task {
            do {
                _ = try await authService.infoCheckEmail(email)
                showNewEmailVerificationStep = true
            } catch let errorResponse as ApiErrorResponse {
                newEmailCheckErrorMessage = errorResponse.message ?? ""
                showNewEmailCheckError = true
            }
        }
    }
    
    func updateEmailAddress() {
        Task {
            do {
                _ = try await authService.tryChangingEmailAddress(newEmail, User.shared.token)
                updateEmailSuccessfully = true
                User.shared.email = newEmail
            } catch {
                failedToUpdateEmail = true
                OHLogInfo("Error: \(error)")
            }
        }
    }
    
    func clearNewEmailCheckError() {
        if showNewEmailCheckError {
            showNewEmailCheckError = false
        }
        
        if !newEmailCheckErrorMessage.isEmpty {
            newEmailCheckErrorMessage = ""
        }
    }
}

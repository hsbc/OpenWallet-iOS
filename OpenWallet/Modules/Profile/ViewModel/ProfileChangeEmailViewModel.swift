//
//  ProfileChangeEmailViewModel.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 7/6/22.
//

import Foundation

@MainActor
class ProfileChangeEmailViewModel: ObservableObject {
    @Published var currentEmail: String = User.shared.email
    @Published var newEmail: String = ""
    
    @Published var isCurrentEmailVerified: Bool = false // If the current email address pass captcha check
    
    @Published var isNewEmailAvailable: Bool = false // If the new email address is available
    @Published var isNewEmailVerified: Bool = false // If the new email address pass captcha check
    
    @Published var isUpdateEmailSuccess: Bool = false
    
    @Published var errorMessage: String = ""
    @Published var warningMessage: String = ""
    
    let authService: AuthService
    
    init(authService: AuthService = AuthService()) {
        self.authService = authService
    }
    
    func updateEmail() {
        cleanupWarningAndErrorMessage()
        
        guard isNewEmailVerified else { return }
        
        Task {
            do {
                isUpdateEmailSuccess = try await authService.tryChangingEmailAddress(newEmail, User.shared.token)

                if !isUpdateEmailSuccess {
                    updateWarningMessage("failed to update email address")
                }
            } catch {
                updateErrorMessage("failed to update email address")
            }
        }
    }
    
    func checkIfNewEmailAvailable() {
        cleanupWarningAndErrorMessage()
        
        guard newEmail.isOpenWalletEmail else {
            updateWarningMessage("only support OpenWallet email")
            return
        }
        
        Task {
            do {
                isNewEmailAvailable = try await authService.isEmailAvailable(newEmail)
                
                if !isNewEmailAvailable {
                    updateWarningMessage("the input email address is not available")
                }
            } catch {
                updateErrorMessage("failed to check if email address is available")
            }
        }
    }
    
    func updateWarningMessage(_ message: String) {
        warningMessage = "WARNING: \(message)."
    }
    
    func updateErrorMessage(_ message: String) {
        errorMessage = "ERROR: \(message)."
    }
    
    func cleanupWarningAndErrorMessage() {
        warningMessage = ""
        errorMessage = ""
    }
}

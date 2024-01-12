//
//  OTPManager.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 10/30/22.
//

import Foundation

class OTPManager: ObservableObject {
    
    class VerifyLimit {
        var smsLimit: Bool = false
        var emailLimit: Bool = false
    }
    
    static let shared = OTPManager()

    @Published var smsOTPCoolOffTime: TimeInterval = 0
    @Published var emailOTPCoolOffTime: TimeInterval = 0
    
    // Use it the track when the OTPVerification view is dismissed in order to
    // substract the time interval the next time OTPVerfication view appear. [weihao.zhang]
    @Published var smsOTPDismissDateTime: Date = Date.distantPast
    @Published var emailOTPDismissDateTime: Date = Date.distantPast

    // Enable enter the verify code
    @Published var emailVerifyLimit: Bool = false {
        didSet {
            OHLogInfo("emailVerifyLimit: \(emailVerifyLimit)")
        }
    }
    @Published var smsVerifyLimit: Bool = false {
        didSet {
            OHLogInfo("smsVerifyLimit: \(smsVerifyLimit)")
        }
    }
    
    private var verifyLimitAccounts: [String: VerifyLimit] = [:]

    var isSMSOTPDismissedBeforeVerified: Bool {
        return self.smsOTPDismissDateTime != Date.distantPast
    }
    
    var isEmailOTPDismissedBeforeVerified: Bool {
        return self.emailOTPDismissDateTime != Date.distantPast
    }
    
    func checkIfSMSIsCoolingOff() -> Bool {
        if self.isSMSOTPDismissedBeforeVerified {
            let timeElapsed = round(Date.now.timeIntervalSince(self.smsOTPDismissDateTime))
            
            if timeElapsed > self.smsOTPCoolOffTime {
                clearSMSOTPCoolOffTime()
                resetSMSOTPDismissDateTime()
            } else {
                self.smsOTPCoolOffTime -= timeElapsed
            }
        }
        
        return self.smsOTPCoolOffTime > 0
    }

    func checkIfEmailIsCoolingOff() -> Bool {
        if self.isEmailOTPDismissedBeforeVerified {
            let timeElapsed = round(Date.now.timeIntervalSince(self.emailOTPDismissDateTime))
            
            if timeElapsed > self.emailOTPCoolOffTime {
                clearEmailOTPCoolOffTime()
                resetEmailOTPDismissDateTime()
            } else {
                self.emailOTPCoolOffTime -= timeElapsed
            }
        }

        return self.emailOTPCoolOffTime > 0
    }
    
    func getLimit(_ userName: String, message: String?) -> (VerifyLimit, Bool) {
        var verifyLimit = verifyLimitAccounts[userName]
        if verifyLimit == nil {
            verifyLimit = VerifyLimit()
        }
        
        var limit = false
        if let msg = message {
            limit = msg.contains(ERRCODE_ACCOUNT_LOCKED)
        }
        return (verifyLimit!, limit)
    }
    
    func checkSmsVerifyLimit(_ userName: String, message: String?) {
        let (verifyLimit, limit) = getLimit(userName, message: message)
        verifyLimit.smsLimit = limit
        verifyLimitAccounts[userName] = verifyLimit
        smsVerifyLimit = limit
    }
    
    func checkEmailVerifyLimit(_ userName: String, message: String?) {
        let (verifyLimit, limit) = getLimit(userName, message: message)
        verifyLimit.emailLimit = limit
        verifyLimitAccounts[userName] = verifyLimit
        emailVerifyLimit = limit
    }

    func clearSMSOTPCoolOffTime() {
        self.smsOTPCoolOffTime = 0
    }

    func clearEmailOTPCoolOffTime() {
        self.emailOTPCoolOffTime = 0
    }
    
    func resetSMSOTPCoolOffTime() {
        self.smsOTPCoolOffTime = 60
    }

    func resetEmailOTPCoolOffTime() {
        self.emailOTPCoolOffTime = 300
    }
    
    func logSMSOTPDismissDateTime() {
        self.smsOTPDismissDateTime = Date.now
    }

    func logEmailOTPDismissDateTime() {
        self.emailOTPDismissDateTime = Date.now
    }
    
    func resetSMSOTPDismissDateTime() {
        self.smsOTPDismissDateTime = Date.distantPast
    }
    
    func resetEmailOTPDismissDateTime() {
        self.emailOTPDismissDateTime = Date.distantPast
    }
    
    func resetSmsVerifyLimit(_ userName: String) {
        guard userName.count > 0 else {
            return
        }
        if let verifyLimit = verifyLimitAccounts[userName] {
            smsVerifyLimit = verifyLimit.smsLimit
            return
        }
        smsVerifyLimit = false
    }
    
    func resetEmailVerifyLimit(_ userName: String) {
        guard userName.count > 0 else {
            return
        }
        if let verifyLimit = verifyLimitAccounts[userName] {
            emailVerifyLimit = verifyLimit.emailLimit
            return
        }
        emailVerifyLimit = false
    }
}

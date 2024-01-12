//
//  ApiEndPointsRouter.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 7/4/22.
//

struct ApiEndPoints {
    // MARK: Auth Service API endpoints
    struct Auth {
        // Captcha check
        static let captchaCheckEmail = "\(EnvironmentConfig.middleLayerBaseUrl)/api/auth/captchacheck/email"
        static let captchaCheckPhone = "\(EnvironmentConfig.middleLayerBaseUrl)/api/auth/captchacheck/phone"
        static let captchaDoubleCheckEmail = "\(EnvironmentConfig.middleLayerBaseUrl)/api/auth/captchadoublecheck/email"
        static let captchaDoubleCheckPhone = "\(EnvironmentConfig.middleLayerBaseUrl)/api/auth/captchadoublecheck/phone"
        
        // Captcha send
        static let captchaSendEmail = "\(EnvironmentConfig.middleLayerBaseUrl)/api/auth/captchasend/email"
        static let captchaSendPhone = "\(EnvironmentConfig.middleLayerBaseUrl)/api/auth/captchasend/phone"

        // Update user contact info
        static let changeEmailAddress = "\(EnvironmentConfig.middleLayerBaseUrl)/api/auth/changeEmailAddress"
        static let changePhoneContent = "\(EnvironmentConfig.middleLayerBaseUrl)/api/auth/changePhoneContent"
        static let changeUserName = "\(EnvironmentConfig.middleLayerBaseUrl)/api/auth/changeUserName"

        // Info check
        static let infoCheckAll = "\(EnvironmentConfig.middleLayerBaseUrl)/api/auth/infocheck/all"
        static let infoCheckEmail = "\(EnvironmentConfig.middleLayerBaseUrl)/api/auth/infocheck/email"
        static let infoCheckPhone = "\(EnvironmentConfig.middleLayerBaseUrl)/api/auth/infocheck/phone"
        static let infoCheckUsername = "\(EnvironmentConfig.middleLayerBaseUrl)/api/customer/username/validate"
        
        // Reset password
        static let resetPasswordEmail = "\(EnvironmentConfig.middleLayerBaseUrl)/api/auth/resetpassword/email"
        static let resetPasswordEmailCode = "\(EnvironmentConfig.middleLayerBaseUrl)/api/auth/resetpassword/emailCode"
        static let resetPasswordPhone = "\(EnvironmentConfig.middleLayerBaseUrl)/api/auth/resetpassword/phone"
        static let resetPassword = "\(EnvironmentConfig.middleLayerBaseUrl)/api/auth/password/reset"
        
        // change password
        static let changePassword = "\(EnvironmentConfig.middleLayerBaseUrl)/api/auth/password/change"
        static let verifyFirstFactorChangePassword = "\(EnvironmentConfig.middleLayerBaseUrl)/api/auth/verify-first-factor/change-password"

        // Sign in
        static let signInEmail = "\(EnvironmentConfig.middleLayerBaseUrl)/api/auth/signin/email"
        static let signInPhone = "\(EnvironmentConfig.middleLayerBaseUrl)/api/auth/signin/phone"
        static let verifyFirstFactorLogin = "\(EnvironmentConfig.middleLayerBaseUrl)/api/auth/verify-first-factor/login"
        static let accessTokenRefresh = "\(EnvironmentConfig.middleLayerBaseUrl)/api/auth/refresh"
        
        // Sign up
        static let signUp = "\(EnvironmentConfig.middleLayerBaseUrl)/api/auth/signup/v1"
        
        // Log out
        static let logout = "\(EnvironmentConfig.middleLayerBaseUrl)/api/auth/logout"
        
        // Avatar
        static let getAvatar = "\(EnvironmentConfig.middleLayerBaseUrl)/api/auth/getavatar"
        static let updateAvatar = "\(EnvironmentConfig.middleLayerBaseUrl)/api/auth/updateavatar"
        
        // Position
        static let queuePosition = "\(EnvironmentConfig.middleLayerBaseUrl)/api/auth/captchasend/queue/position"
        
        // Country code
        static let getCountryCode = "\(EnvironmentConfig.middleLayerBaseUrl)/api/auth/get-countrycode"
    }
    
    struct Activity {
        static let getActivity = "\(EnvironmentConfig.middleLayerBaseUrl)/api/activity/getactivity"
        static let getquiz = "\(EnvironmentConfig.middleLayerBaseUrl)/api/activity/getquiz/"
        static let getquizByToken = "\(EnvironmentConfig.middleLayerBaseUrl)/api/activity/getquiz/token/"
        static let getLuckyDraw = "\(EnvironmentConfig.middleLayerBaseUrl)/api/activity/list/luckydraw"
        static let isActivityFinished = "\(EnvironmentConfig.middleLayerBaseUrl)/api/activity/isactivityfinished/"
    }
    
    struct Captcha {
        static let captchaValidate = "\(EnvironmentConfig.middleLayerBaseUrl)/api/captcha/validate"
        static let captchaSend = "\(EnvironmentConfig.middleLayerBaseUrl)/api/captcha/send"
    }
    
    struct Quiz {
        static let getQuestion = "\(EnvironmentConfig.middleLayerBaseUrl)/api/quiz/getquestion/"
        static let verifyAnswer = "\(EnvironmentConfig.middleLayerBaseUrl)/api/question/verifyAnswer/"
        static let updateQuiz = "\(EnvironmentConfig.middleLayerBaseUrl)/api/quiz/updateStatus/"
    }

    struct Wallet {
        static let getContractList = "\(EnvironmentConfig.middleLayerBaseUrl)/api/wallet/contract/list"
        static let getContractDetail = "\(EnvironmentConfig.middleLayerBaseUrl)/api/wallet/erc721/tokens"
    }
    
    struct NFT {
        static let getNFTList = "\(EnvironmentConfig.middleLayerBaseUrl)/api/blockchain/nft/list"
        static let hasExpiringToken = "\(EnvironmentConfig.middleLayerBaseUrl)/api/blockchain/nft/check/hasExpiringToken"
    }
    
    // MARK: Notification Service API endpoints
    struct Notification {
        static let addNotification = "\(EnvironmentConfig.middleLayerBaseUrl)/api/notification/add"
        static let getNotifications = "\(EnvironmentConfig.middleLayerBaseUrl)/api/notification/list"
        static let updateStatus = "\(EnvironmentConfig.middleLayerBaseUrl)/api/notification/status/update"
    }

    struct FAQ {
        static let getFAQ = "\(EnvironmentConfig.middleLayerBaseUrl)/api/faq/list"
    }

    struct Ipfs {
        static let getGatewayDomain = "\(EnvironmentConfig.middleLayerBaseUrl)/api/ipfs/getGatewayDomain"
    }
    
    // MARK: Bank Service API endpoints
    struct Bank {
        static let getInfo = "\(EnvironmentConfig.middleLayerBaseUrl)/api/bank/info"
    }
    
    // MARK: Delivery Service API endpoints
    struct Delivery {
        static let createDelivery = "\(EnvironmentConfig.middleLayerBaseUrl)/api/delivery/create"
    }

    // MARK: Customer Service API endpoints
    struct Customer {
        static let validateEmail = "\(EnvironmentConfig.middleLayerBaseUrl)/api/customer/email/validate"
        static let validatePassword = "\(EnvironmentConfig.middleLayerBaseUrl)/api/customer/password/validate"
        static let validatePhone = "\(EnvironmentConfig.middleLayerBaseUrl)/api/customer/phone/validate"
        static let validateUsername = "\(EnvironmentConfig.middleLayerBaseUrl)/api/customer/username/validate"
        static let getProfile = "\(EnvironmentConfig.middleLayerBaseUrl)/api/customer/profile/get"
        static let updateProfile = "\(EnvironmentConfig.middleLayerBaseUrl)/api/customer/profile/update"
        static let modifyStatus = "\(EnvironmentConfig.middleLayerBaseUrl)/api/customer/status/modify"
        static let register = "\(EnvironmentConfig.middleLayerBaseUrl)/api/customer/register"
        static let registerUsername = "\(EnvironmentConfig.middleLayerBaseUrl)/api/customer/register/username"
        static let registerPassword = "\(EnvironmentConfig.middleLayerBaseUrl)/api/customer/register/password"
        static let updateStatus = "\(EnvironmentConfig.middleLayerBaseUrl)/api/customer/status/update?status=%@"

    }

    // MARK: Feedback Service API endpoints
    struct Feedback {
        static let sendFeedback = "\(EnvironmentConfig.middleLayerBaseUrl)/api/feedback/send"
    }
    
    // MARK: TnC Service API endpoints
    struct TnC {
        static let getTncByCategoryAndLanguage = "\(EnvironmentConfig.middleLayerBaseUrl)/api/tnc/{category}/{language}"
    }

}

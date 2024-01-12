//
//  NetworkErrCodeDefine.swift
//  OpenWallet
//
//  Created by TQ on 2022/10/12.
//

import Foundation

// Should check periodically from http://34.76.94.214/developer/midlayer/-/wikis/Error-code-table

// Failed to fetch country code
let ERRCODE_COUNTRY_CODE_FETCH_FAILED: String = "0x10000000"
// Failed to create delivery
let ERRCODE_DELIVERY_CREATE_FAILED: String = "0x10000001"
// The account has been locked for several hours
let ERRCODE_ACCOUNT_LOCKED: String = "0x10000002"
// The account is not active
let ERRCODE_ACCOUNT_NOT_ACTIVE: String = "0x10000003"
// Activity already exist
let ERRCODE_ACTIVITY_ALREADY_EXIST: String = "0x10000004"
// Activity not exist
let ERRCODE_ACTIVITY_NOT_EXIST: String = "0x10000005"
// Argument is invalid
let ERRCODE_ARGUMENT_INVALID: String = "0x10000006"
// Authentication failed
let ERRCODE_AUTHENTICATION_FAILED: String = "0x10000007"
// Email is already in use
let ERRCODE_EMAIL_ALREADY_IN_USE: String = "0x10000008"
// This email is not eligible
let ERRCODE_EMAIL_NOT_IN_BANK_ACCOUNT: String = "0x10000009"
// Email resource is exhausted
let ERRCODE_EMAIL_RESOURCE_EXHAUSTED: String = "0x1000000a"
// Email sent too frequent
let ERRCODE_EMAIL_SENT_TOO_FREQUENT: String = "0x1000000b"
// The process is taking too long, Please start over
let ERRCODE_EXCEED_TIME_LIMIT: String = "0x1000000c"
// Faq already exist
let ERRCODE_FAQ_ALREADY_EXIST: String = "0x1000000d"
// Faq not exist
let ERRCODE_FAQ_NOT_EXIST: String = "0x1000000e"
// This account has been locked
let ERRCODE_LOCKED: String = "0x1000000f"
// Notification not exist
let ERRCODE_NOTIFICATION_NOT_EXIST: String = "0x10000010"
// The process is not sequential
let ERRCODE_OUT_OF_SEQUENCE: String = "0x10000011"
// Accept combination of lower and/or upper case letters, numbers, or underscore(_) only
let ERRCODE_PASSWORD_INVALID: String = "0x10000012"
// Phone number is already in use
let ERRCODE_PHONE_ALREADY_IN_USE: String = "0x10000013"
// Phone number is not eligible
let ERRCODE_PHONE_NOT_IN_BANK_ACCOUNT: String = "0x10000014"
// Receiver not exist
let ERRCODE_RECEIVER_NOT_EXIST: String = "0x10000015"
// SMS resource is exhausted
let ERRCODE_SMS_RESOURCE_EXHAUSTED: String = "0x10000016"
// SMS sent in gap
let ERRCODE_SMS_SENT_IN_GAP: String = "0x10000017"
// SMS sent too frequent
let ERRCODE_SMS_SENT_TOO_FREQUENT: String = "0x10000018"
// Tokens do not match
let ERRCODE_TOKEN_MISMATCH: String = "0x10000019"
// Username is already taken
let ERRCODE_USERNAME_IN_USE: String = "0x1000001a"
// The username should be 6–30 characters long and can be any combination of lower and/or upper case letters, numbers, or underscore(_)
let ERRCODE_USERNAME_INVALID: String = "0x1000001b"
// User not exist
let ERRCODE_USER_NOT_EXIST: String = "0x1000001c"
// Failed to update customer account status
let ERRCODE_FAIL_TO_UPDATE_CUSTOMER_STATUS: String = "0x1000001d"
// Failed to get nft token detail
let ERRCODE_NFT_TOKEN_DETAIL_FETCH_FAILED: String = "0x11000000"
// Failed to get nft token image
let ERRCODE_NFT_TOKEN_IMAGE_FETCH_FAILED: String = "0x11000001"
// Failed to get nft list
let ERRCODE_NFT_LIST_FETCH_FAILED: String = "0x11000002"
// Failed to check expiring token
let ERRCODE_EXPIRING_TOKEN_CHECK_FAILED: String = "0x11000003"
// Nft already redeemed
let ERRCODE_NFT_ALREADY_REDEEMED: String = "0x11000004"
// Nft not exist
let ERRCODE_NFT_NOT_EXIST: String = "0x11000005"
// Captcha do not match
let ERRCODE_CAPTCHA_MISMATCH: String = "0x12000000"
// Failed to get bank info
let ERRCODE_BANK_INFO_FETCH_FAILED: String = "0x20000000"
// Bank account is not exist
let ERRCODE_BANK_ACCOUNT_NOT_EXIST: String = "0x20000001"
// Bank account is not allowed to register
let ERRCODE_NOT_ALLOW_TO_REGISTER: String = "0x20000002"
// Failed to unlock delivery
let ERRCODE_DELIVERY_UNLOCK_FAILED: String = "0x20000003"
// Notification has already been assigned to this user.
let ERRCODE_NOTIFICATION_ALREADY_ASSIGNED: String = "0x20000004"

//
//  String.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 7/6/22.
//

import Foundation

extension String {
    var isAcceptableEmail: Bool {
        // Modify acceptable email check here. Currently only support OpenWallet email.
        return !self.isEmpty && self.isOpenWalletEmail
    }
    
    var isEmail: Bool {
        let regex = NSRegularExpression(#"^\S+@\S+\.\S+$"#)
        return regex.test(self)
    }
    
    var isValidPhoneNumber: Bool {
        // TODO: check
        // getMaskedForm 这个方法限制裁定 index 6，所以这里要大于 6.
        // 为什么需要这个方法，原因是需要给数字中间加星，例如 135****3109，之后不确定是否可以去掉。
        return self.count > 6
    }
    
    var isOpenWalletEmail: Bool {
        let regex = NSRegularExpression(#"^\S+@OpenWallet.com(?:\.\S{2})?$"#)
        return regex.test(self)
    }
    
    var isAcceptableUsername: Bool {
        // Acceptable username should be 6–30 characters long,
        // and can be any combination of lower and/or upper case letters, numbers, or underscore(_)
        let lengthRegex = NSRegularExpression(#"(?=^.{6,30}$)"#)
        let contentRegex = NSRegularExpression(#"([a-z|A-Z|0-9|_])"#)
        let isAcceptable = lengthRegex.test(self) && contentRegex.getNumberOfCount(self) == self.count

        return isAcceptable
    }
    
    var isPasswordFullfilledLengthRequirement: Bool {
        let lengthRegex = NSRegularExpression(#"(?=^.{8,20}$)"#)
        let isLengthWithinRange = lengthRegex.test(self)
        return isLengthWithinRange
    }
    
    var isAcceptablePassword: Bool {
        // Password must be 8-20 characters, includes at least three of the four types: upper/lower letters, number or symbols.
//        let passwordRegex = NSRegularExpression(#"(?=^.{8,20}$)((?=.*\d)(?=.*[a-z])(?=.*[A-Z])|(?=.*\d)(?=.*[a-zA-Z])(?=.*[\W_])|(?=.*[a-z])(?=.*[A-Z])(?=.*[\W_])).*"#)
//        let isAcceptable = passwordRegex.test(self)
        //  Special characters need to be escaped { => \{
        let regex =
        NSRegularExpression( #"(?=.{8,20}$)((?=.*\d)(?=.*[a-z])(?=.*[A-Z])(^[a-zA-Z0-9_@#\$%&<>\(\)\[\]\{\}\^\-=!\|\?\*\+\.\\\/]*$)|(?=.*\d)(?=.*[a-zA-Z])(?=.*[\W_])(^[a-zA-Z0-9_@#\$%&<>\(\)\[\]\{\}\^\-=!\|\?\*\+\.\\\/]*$)|(?=.*[a-z])(?=.*[A-Z])(?=.*[\W_])(^[a-zA-Z0-9_@#\$%&<>\(\)\[\]\{\}\^\-=!\|\?\*\+\.\\\/]*$)).*"#)
        let isAcceptable1 = regex.test(self)
        return isAcceptable1

    }
    var isHaveChineseCharacter: Bool {
        return self.range(of: "\\p{Han}", options: .regularExpression) != nil
    }
    
    var isHaveArabicCharacter: Bool {
        return self.range(of: "\\p{Arabic}", options: .regularExpression) != nil
    }
    
    func maskSubrangeWithAsterisk(range: Range<String.Index>) -> String {
        var stringToMask = self

        let start = range.lowerBound.utf16Offset(in: stringToMask)
        let end = range.upperBound.utf16Offset(in: stringToMask)
        stringToMask.replaceSubrange(range, with: String(repeating: "*", count: end - start))
        
        return stringToMask
    }
    
    func toData() -> Data {
        return Data(self.utf8)
    }
    
    func base64Encoded() -> String? {
        data(using: .utf8)?.base64EncodedString()
    }

    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

extension String: Identifiable {
    public typealias ID = Int
    public var id: Int {
        return hash
    }
}

extension String {
    func getMaskedFormEmail() -> String {
        guard !self.isEmpty && self.isEmail else {
            return ""
        }
        let emailArray = self.components(separatedBy: "@")
        if emailArray.first!.count > 3 {
        let rangeStart = self.index(self.startIndex, offsetBy: 3)
        let rangeEnd = self.firstIndex(of: "@")!
        let range = rangeStart..<rangeEnd
        return "\(self.maskSubrangeWithAsterisk(range: range))"
        } else {
            return "\(emailArray.first!)******@\(emailArray.last!)"
        }
    }
    
    func isLengthMatch(min: Int, max: Int) -> Bool {
        let isAcceptable = self.count >= min && self.count <= max
        return isAcceptable
    }

}

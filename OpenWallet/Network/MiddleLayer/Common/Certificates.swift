//
//  Certificates.swift
//  OpenWalletStaff
//
//  Created by WEIHAO ZHANG on 8/29/22.
//

import Foundation

struct Certificates {
    static let serverCertificate = Certificates.getCertificate(fileName: EnvironmentConfig.serverCertificateFileName, fileExtension: EnvironmentConfig.serverCertificateFileExtension)
    
    private static func getCertificate(fileName: String, fileExtension: String) -> SecCertificate {
        guard let filePath = Bundle.main.path(forResource: fileName, ofType: fileExtension) else { fatalError("\(fileName) can not be found.") }
        guard let data = NSData(contentsOfFile: filePath) else { fatalError("Failed to load certificate file.") }
        guard let certificate = SecCertificateCreateWithData(nil, data) else { fatalError("Failed to read certificate.") }
        
        return certificate
    }
}

//
//  OHLogger.swift
//  OpenWallet
//
//  Created by fanjianrong on 2022/10/27.
//

import Foundation
#if canImport(CocoaLumberjackSwift)
import CocoaLumberjackSwift
#endif
import ZipArchive

class OHLogger {
    static let shared = OHLogger()
    
    var isArchiving: Bool = false
    var didShow: Bool = false
    
    func setup() {
#if canImport(CocoaLumberjackSwift)
        DDLog.add(DDOSLogger.sharedInstance) // Uses os_log

        let fileManager = DDLogFileManagerDefault(logsDirectory: cacheDirectoryPath())
        let fileLogger: DDFileLogger = DDFileLogger(logFileManager: fileManager) // File Logger
        fileLogger.rollingFrequency = 60 * 60 * 24 // 24 hours
        fileLogger.maximumFileSize = 1024 * 1024
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        print(fileLogger.logFileManager.logsDirectory)
        DDLog.add(fileLogger)
#endif
    }
}

@inlinable
public func OHLogDebug(_ message: @autoclosure () -> Any) {
 #if canImport(CocoaLumberjackSwift)
    DDLogDebug(message())
 #else
    print(message())
 #endif
}

@inlinable
public func OHLogInfo(_ message: @autoclosure () -> Any) {
#if canImport(CocoaLumberjackSwift)
    DDLogInfo(message())
#else
   print(message())
#endif
}

@inlinable
public func OPLogWarn(_ message: @autoclosure () -> Any) {
#if canImport(CocoaLumberjackSwift)
    DDLogWarn(message())
#else
   print(message())
#endif
}

@inlinable
public func OHLogVerbose(_ message: @autoclosure () -> Any) {
#if canImport(CocoaLumberjackSwift)
    DDLogVerbose(message())
#else
   print(message())
#endif
}

@inlinable
public func OHLogError(_ message: @autoclosure () -> Any) {
#if canImport(CocoaLumberjackSwift)
    DDLogError(message())
#else
   print(message())
#endif
}

extension OHLogger {
    func cacheDirectoryPath() -> String {
        let manager = FileManager.default
        let urls: [URL] = manager.urls(for: .cachesDirectory, in: .userDomainMask)
        let cacheUrl = urls.first!
        let url = cacheUrl.appendingPathComponent("Logs", isDirectory: true)
        var isDirectory: ObjCBool = ObjCBool(false)
        let isExist = manager.fileExists(atPath: url.path, isDirectory: &isDirectory)
        if !isExist {
          do {
            try manager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
          } catch {
            print("createDirectory error:\(error)")
          }
        }
        return url.path
    }
    
    func archiveLogFile() -> String {
        isArchiving = true
        didShow = true
        let path = cacheDirectoryPath()
        let zipPath = path.appending(".zip")
        if SSZipArchive.createZipFile(atPath: zipPath, withContentsOfDirectory: path) {
            OHLogInfo("archiveLogFile success")
        } else {
            OHLogInfo("archiveLogFile failed")
        }
        isArchiving = false
        return zipPath
    }
}

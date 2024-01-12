//
//  DebugHelper.swift
//  OpenWallet
//
//  Created by yushihang on 2022/11/1.
//

import SwiftUI

// Usage
// var body: some View {
//    let _ = DebugHelper.debugPrintViewRebuildLog(Self.self)
//    EmptyView()
// }

struct DebugHelper {
    static func debugPrintViewRebuildLog(
        _ view: any View.Type,
        fileID: String = #fileID,
        file: String = #file,
        function: String = #function,
        column: Int = #column,
        line: Int = #line
    ) {
#if DEBUG
        let viewTypeString = String(describing: type(of: view))
        let viewName = String(viewTypeString[viewTypeString.startIndex ..< viewTypeString.index(viewTypeString.endIndex, offsetBy: -(".Type".count))])
        _ = print("\n🏗️🏗️🏗️🏗️🏗️ View Rebuild:\(viewName) 🧱🧱🧱🧱🧱")
        _ = print("ViewName: \(viewName)")
        _ = print("FileName: \(fileID)")
        _ = print("FilePath: \(file)")
        _ = print("FunctionName: \(function)")
        _ = print("Line: \(line)")
        _ = view._printChanges()
        _ = print("\n")
#endif
    }
}

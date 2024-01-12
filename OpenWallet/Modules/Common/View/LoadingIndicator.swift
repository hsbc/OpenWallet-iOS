//
//  LoadingIndicator.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 10/19/22.
//

import SwiftUI

/**
 An loading indicator can be used while the view if loading data.
 */
struct LoadingIndicator: View {
    var body: some View {
        VStack {
            Spacer()
            ProgressView()
            Spacer()
        }
    }
}

struct LoadingIndicator_Previews: PreviewProvider {
    static var previews: some View {
        LoadingIndicator()
    }
}

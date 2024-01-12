//
//  NavigationButton.swift
//  OpenWallet
//
//  Created by Jianrong Fan on 2022/10/18.
//

import SwiftUI

/// Handling custom gesture & navigate conflicts
struct NavigationButton<Destination: View, Content: View>: View {
    var action: () -> Void = { }
    var destination: () -> Destination
    var content: () -> Content

    @State private var isActive: Bool = false

    var body: some View {
        ZStack {
            self.content()
              .background(
                ScrollView { // Fixes a bug where the navigation bar may become hidden on the pushed view
                    NavigationLink(destination: LazyDestination { self.destination() },
                                                 isActive: self.$isActive) { EmptyView() }
                }
              )
        }.gesture(TapGesture().onEnded {
            self.isActive = true
        })
    }
}

// This view lets us avoid instantiating our Destination before it has been pushed.
struct LazyDestination<Destination: View>: View {
    var destination: () -> Destination
    var body: some View {
        self.destination()
    }
}

//
//  CardTitleView.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/7/6.
//

import SwiftUI

struct CardTitleView: View {
    var itemList: ItemListModel
    
    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            Text(itemList.title)
                .font(.title2)
            if itemList.isComingSoon {
                Text("Coming soon!")
                    .font(.subheadline)
                    .foregroundColor(Color("#4eadad"))
                    .background(Color("#f2f2f2"))
            }
            
        }
    }
}

struct CardTitleView_Previews: PreviewProvider {
    static var previews: some View {
        CardTitleView(itemList: CardViewModel().itemLists[0])
    }
}

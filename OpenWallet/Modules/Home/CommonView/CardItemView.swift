//
//  CardItemView.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/7/6.
//

import SwiftUI

struct CardItemView: View {
    var item: ItemModel
    var body: some View {
        
        VStack(alignment: .center) {
            item.image
                .resizable()
                .scaledToFit()
                .frame(height: UIScreen.main.bounds.height*0.1)
                .cornerRadius(5)
            Text(item.itemName)
                .lineLimit(2)
                .foregroundColor(.primary)
                .font(.caption)
        }.frame(width: UIScreen.main.bounds.width*0.24)
        .padding(.trailing, 15)
        
    }
}

struct CardItemView_Previews: PreviewProvider {
    static var previews: some View {
        CardItemView(item: CardViewModel().itemLists[0].items[2])
    }
}

//
//  ProjectItemView.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/7/6.
//

import SwiftUI

struct ProjectItemView: View {
    var item: ItemModel
    var body: some View {
        
        VStack(alignment: .leading) {
            item.image
                .resizable()
                .frame(height: UIScreen.main.bounds.height*0.097)
                .aspectRatio(contentMode: .fill)
            Text(item.itemName)
                .lineLimit(2)
                .foregroundColor(.primary)
                .font(.callout)
        }
        .frame(width: UIScreen.main.bounds.width*0.32)
        .background(Color("#f2f2f2"))
        .cornerRadius(5)
        .padding(.trailing, 15)
        
    }
}

struct ProjectItemView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectItemView(item: CardViewModel().projectsLists[0].items[1])
    }
}

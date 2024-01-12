//
//  CardBlockView.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/7/6.
//

import SwiftUI

struct CardBlockView: View {
    var listModel: ItemListModel
    var isShowBackground: Bool=false
    @Binding var showAlert: Bool
    var body: some View {
        VStack(alignment: .leading) {
            CardTitleView(itemList: listModel)
            
            ScrollView(.horizontal, showsIndicators: false) {
                
                    HStack(alignment: .top, spacing: 0) {
                        ForEach(listModel.items) { items in
                            Button(action: {
                                showAlert=true
                            }, label: {
                                if isShowBackground {
                                    ProjectItemView(item: items)
                                } else {
                                    CardItemView(item: items)
                                }
                            })
                            
//                            NavigationLink {
//                                //CardItemView(item: items)
//
//                            } label: {
//                                if(isShowBackground){
//                                    ProjectItemView(item: items)
//                                }else{
//                                    CardItemView(item: items)
//                                }
//                            }
                        }
                    }
            }
            
        }
    }
}

struct CardBlockView_Previews: PreviewProvider {
    @State static var isShow: Bool=false
    static var previews: some View {
        CardBlockView(listModel: CardViewModel().projectsLists[0], showAlert: $isShow)
    }
}

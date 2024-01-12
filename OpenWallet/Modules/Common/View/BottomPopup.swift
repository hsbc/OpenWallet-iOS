//
//  BottomPopup.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/9/15.
//

import SwiftUI

struct BottomPopup: View {
    @Binding var show: Bool
    @State var title = ""
    @State var content = ""

    var body: some View {
        ZStack {
            if !show {
                EmptyView()
            } else {
                Color("#000000").opacity(0.2).edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading) {
                        HStack {
                            Text(title)
                                .font(Font.custom("SFProText-Regular", size: FontSize.title4))
                            Spacer()
                            Image("Close")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 19.8, height: 19.8)
                                .onTapGesture {
                                    show.toggle()
                                }
                        }
                        .padding(.top, UIScreen.screenHeight*0.023)
                        .padding(.bottom, UIScreen.screenHeight*0.021)
                        .padding(.horizontal, UIScreen.screenWidth*0.043)

                        Text(content)
                            .font(Font.custom("SFProText-Medium", size: FontSize.info))
                            .padding(.horizontal, UIScreen.screenWidth*0.043)
                    }
                    .frame(width: UIScreen.screenWidth)
                    .frame(maxHeight: UIScreen.screenHeight, alignment: .topLeading)
                    .background(.white)
                    .cornerRadius(10)
                    .padding(.top, UIScreen.screenHeight*0.6)
                    .ignoresSafeArea(.all, edges: .bottom)
                    .animation(.spring())
                    .transition(.move(edge: .bottom))

            }
        }
    }
}

struct BottomPopup_Previews: PreviewProvider {
    @State static var show = true
    static var previews: some View {
        BottomPopup(show: $show, title: "this is title", content: "content!!!!")
    }
}

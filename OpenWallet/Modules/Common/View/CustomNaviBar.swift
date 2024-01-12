//
//  CustomNaviBar.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/7/12.
//

import SwiftUI

struct CustomNaviBar: View {
    var showBack=false
    var title=""
    var showExit=false
    @Environment(\.dismiss) var dismiss
    
    var backCall: (() -> Void)?
    var exitCall: (() -> Void)?
    
    @ObservedObject var viewModel: LearnViewModel
    
    var body: some View {
        
        ZStack(alignment: .center) {
            
            if showBack {
                HStack {
                    Image(systemName: "chevron.backward")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .onTapGesture {
                            guard backCall != nil else {
                                dismiss()
                                return
                            }
                            backCall!()
                            dismiss()
                        }

                    Spacer()
                }
            } else {
                HStack {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .onTapGesture {
                            guard backCall != nil else {
                                dismiss()
                                return
                            }
                            backCall!()
                            viewModel.backToArticle.toggle()
                        }

                    Spacer()
                }
            }
            
            Text(title)
                .font(Font.custom("SFProText-Medium", size: FontSize.body))
                .frame(height: 24)
        }

// Comment it out temporarily for future development
//        ZStack{
//           // Color.clear.background(.red)
//            HStack{
//
//                if !showBack{
//                    Image(systemName: "chevron.backward")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 24, height: 24)
//                        .onTapGesture {
//
//                            guard backCall != nil else {
//                                dismiss()
//                                return
//                            }
//                            backCall!()
//                            dismiss()
//                        }
//                }
//                Spacer()
//                Text(Title)
//                    .font(Font.custom("SFProText-Medium", size: FontSize.body))
//                    .frame(height: 24)
//
//                Spacer()
//                if showExit{
//                    Image(systemName: "xmark").resizable()
//                        .frame(width: 15, height: 15, alignment: .center).onTapGesture {
//                            guard exitCall != nil else {
//                                dismiss()
//                                return
//                            }
//                            exitCall!()
//                            viewModel.backToArticle.toggle()
//                        }
//                }
//
//            }.padding(.horizontal,20)
//
//        }.frame(height: UIScreen.main.bounds.height*0.02)
//            .frame(maxHeight: .infinity,alignment: .top)
//            .padding(.top,8)
    }
}

struct CustomNaviBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomNaviBar(title: "Question 1/3", viewModel: LearnViewModel())
    }
}

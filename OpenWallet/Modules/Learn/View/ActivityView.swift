//
//  ActivityView.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/7/11.
//

import SwiftUI

struct ActivityView: View {
    
    var quiz: QuizModel
    var index: Int=0

    var isOpen: Bool = false
    
    var isCompeleted: Bool = true

    var body: some View {
        ZStack(alignment: .topTrailing) {
            
            VStack(alignment: .leading, spacing: 0) {
                
                if quiz.imageLinks.count>0 {
                    Image(quiz.imageLinks[0])
                        .resizable()
                        .frame(maxHeight: UIScreen.screenHeight*0.1989)
                        .accessibilityHidden(true)
                }
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(quiz.subject)
                            .font(Font.custom("SFProText-Medium", size: FontSize.body))
                            .foregroundColor(Color("#333333"))
                            .padding(.top, UIScreen.screenHeight*0.017)
                        
                        Text("2min")
                            .font(Font.custom("SFProText-Regular", size: FontSize.label))
                            .foregroundColor(Color("#333333"))
                    }.padding(.leading, UIScreen.screenWidth*0.042)
                    
                    Spacer()
                }
                
                if isCompeleted {
                    HStack {
                        Spacer()
                        HStack {
                            Image("Award")
                                .resizable()
                                .scaledToFit()
                                .frame(height: UIScreen.main.bounds.height*0.025)
                                .foregroundColor(.white)
                                .offset(x: UIScreen.main.bounds.width*0.03)
                                .padding(.horizontal, 5)
                            
                            Text("Completed")
                                .font(Font.custom("SFProText-Medium", size: FontSize.caption))
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: UIScreen.screenWidth*0.285, maxHeight: UIScreen.screenHeight*0.032)
                        .background(Color("#00847f").opacity(0.7))
                        .cornerRadius(20, corners: [.topLeft, .bottomLeft])
                        .accessibilityLabel("Quiz completed")
                    }
                }
                
                Spacer()
            }
            .border(Color("#ededed"), width: 1)
            .frame(width: UIScreen.main.bounds.width*0.914, height: UIScreen.main.bounds.height*0.294, alignment: .leading)
            
            if !isOpen {
                Image("Lock Document")
                    .resizable()
                    .foregroundColor(.black)
                    .frame(width: 24, height: 24)
                    .padding([.top, .trailing], 12)
                    .accessibilityLabel("Quiz is not open")
            }
        }
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView(quiz: QuizModel(id: 1, imageLinks: ["cryptocurrency_learn_list_banner"], description: "asd", subject: "What is blockchain?"))
    }
}

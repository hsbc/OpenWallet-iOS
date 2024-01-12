//
//  QuestionView.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/7/11.
//

import SwiftUI
import Foundation

struct QuestionView: View {
    var quizId: String
    var isLastQuiz: Bool

    @State var nextQuestion = false
    @State var isCompleted = false
    @ObservedObject var viewModel: LearnViewModel
    
    @State var selectedIndex: Int?
    @State var showAlert = false
    @State var buttonText = "Next"
    @State var isLoading = false
    
    @State var backToLearn: Bool = false
    
    @State var navigationDestination: String?
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                CustomNaviBar(showBack: false, title: "Qusestion \(viewModel.questionIndex+1) / \(viewModel.questionLists.count) ", showExit: true, backCall: exitCallBack, exitCall: exitCallBack, viewModel: viewModel)
                    .padding(.horizontal, UIScreen.screenWidth*0.029)
                    .padding(.top, UIScreen.screenHeight*0.0136)

                NavigationLink(isActive: $nextQuestion) {
                    QuestionView(quizId: quizId, isLastQuiz: isLastQuiz, viewModel: viewModel).navigationBarHidden(true)
                } label: {
                    EmptyView()
                }
                
                NavigationLink(
                    destination: ClosableView(content: {
                                    NavigationLink(
                                        destination: MainView().modifier(HideNavigationBar()),
                                        isActive: $backToLearn
                                    ) {
                                        EmptyView()
                                    }
                        
                                    SuccessView(
                                        detailInfo: "You have successfully enrolled in the lucky draw.",
                                        buttonText: "Back to home",
                                        destination: { MainView().modifier(HideNavigationBar()) }
                                    )
                                    .onAppear {
                                        AppState.shared.selectedTab = Tab.home
                                    }
                                }, onCloseClick: {
                                    AppState.shared.selectedTab = Tab.learn
                                    backToLearn.toggle()
                                }).modifier(HideNavigationBar()),
                    isActive: $isCompleted
                ) {
                    EmptyView()
                }

                ZStack(alignment: .topLeading) {
                    
                    if viewModel.questionLists[viewModel.questionIndex].resourceLinks.count>0 {
                        Image(viewModel.questionLists[viewModel.questionIndex].resourceLinks[0])
                            .resizable()
                            .frame(height: UIScreen.main.bounds.height*0.287)
                            .padding(.top, UIScreen.screenHeight*0.024)
                    }
                    
                    if showAlert {
                        HStack {
                            Image(systemName: "exclamationmark.triangle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: UIScreen.main.bounds.width*0.053)
                                .foregroundColor(Color("#a8000b"))
                                .background(.white)
                                
                                .padding(.leading, UIScreen.screenWidth*0.042)
                            Text("Your answer is wrong, please try again.")
                                .font(Font.custom("SFProText-Regular", size: FontSize.warning))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: UIScreen.screenHeight*0.059)
                        .background(Color("#730014"))
                        .offset(y: UIScreen.screenHeight*0.024)
                        .onAppear {
                            // Dismiss launch after after certain duration time
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showAlert = false
                            }
                            
                        }
                        
                    }
                }
                
                if viewModel.questionLists.count>0 {
                    // question
                    Text(viewModel.questionLists[viewModel.questionIndex].question)
                        .font(Font.custom("SFProDisplay-Regular", size: FontSize.title1))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, UIScreen.screenHeight*0.032)
                        .padding(.bottom, UIScreen.screenHeight*0.019)
                        .padding(.leading)

                    // choices
                    ScrollView {
                        VStack(spacing: 0) {
                            
                            ForEach(viewModel.questionLists[viewModel.questionIndex].choices.indices, id: \.self) {index in
                                newChoicView(subIndex: index,
                                             flag: viewModel.questionLists[viewModel.questionIndex].choices[index].components(separatedBy: "/")[0],
                                             content: viewModel.questionLists[viewModel.questionIndex].choices[index].components(separatedBy: "/")[1],
                                             questionId: String(viewModel.questionLists[viewModel.questionIndex].question.id))

                                Divider()
                                 .frame(height: 1)
                                 .background(Color("#ededed"))
                            }

                            Spacer()
                        }
                    }
                }
                
                Spacer()
                ActionButton(text: buttonText, isLoading: $isLoading, action: {
                    isLoading = true
                    Task {
                        guard selectedIndex != nil else { return }

                        let isCorrect = await viewModel.verifyAnswer(questionId: String(viewModel.questionLists[viewModel.questionIndex].id),
                                                                     answer: viewModel.questionLists[viewModel.questionIndex].choices[selectedIndex!].components(separatedBy: "/")[0]
                        )
                        if isCorrect {
                            if buttonText=="Submit" {
                                let updateresult = await viewModel.updateQuizState(quizId: quizId)
                                isLoading = false
                                if !updateresult {
                                    return
                                }
                                // last quiz
                                if isLastQuiz {
                                    // check is activity finished when complete the last quiz. [weihao.zhang]
                                    isCompleted = await viewModel.isActivityFinished()
                                } else {
                                    viewModel.backToLearn.toggle()
                                }
                                
                            } else {
                                viewModel.incrementQuestionIndex()
                                nextQuestion = true
                            }
                        } else {
                            showAlert = true
                        }
                        isLoading = false
                    }
                })
                .padding([.leading, .trailing, .bottom], 16)
            }
        }.onAppear {
            if (viewModel.questionIndex+1) == viewModel.questionLists.count {
                buttonText="Submit"
            }
        }
    }
    
}

extension QuestionView {
    func backCallBack() {
        if viewModel.questionIndex != 0 {
            viewModel.questionIndex-=1
        }
    }
    
    func exitCallBack() {
        viewModel.questionIndex = 0
    }
    
    func newChoicView(subIndex: Int, flag: String, content: String, questionId: String)-> some View {
        return Group {
            HStack {
                Text(content)
                    .font(Font.custom("SFProText-Regular", size: FontSize.body))
                    .padding(.leading)
                
                Spacer()
                
                ZStack {
                    Circle()
                        .inset(by: 20)
                        .stroke(subIndex==selectedIndex ? .black : Color("#767676"), lineWidth: 1)
                    
                    if subIndex==selectedIndex {
                        Circle()
                        .frame(width: 18, height: 18)
                    }

                }
                .frame(maxWidth: UIScreen.main.bounds.height*0.076)
                
            }
            .frame(height: UIScreen.main.bounds.height*0.076)
            .foregroundColor(.black)
            .onTapGesture {
                self.selectedIndex = subIndex
            }
        }
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView(quizId: "001", isLastQuiz: false, viewModel: LearnViewModel())
    }
}

//
//  ArticleView.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/7/11.
//

import SwiftUI

struct ArticleView: View {
    @Environment(\.dismiss) var dismiss
    @State private var starQuiz = false
    @State var showSignRedirect: Bool = false
    var quiz: QuizModel
    var question: QuestionModel?
    @ObservedObject var viewModel: LearnViewModel
    var isLastQuiz: Bool
    @State var isLoading = false

    var body: some View {
        NavigationLink(isActive: $showSignRedirect) {
            SignInRedirector()
        } label: {
            EmptyView()
        }

        NavigationLink(isActive: $starQuiz) {
            QuestionView(
                quizId: String(quiz.id),
                isLastQuiz: isLastQuiz,
                viewModel: viewModel
            ).navigationBarHidden(true)
        } label: {
            EmptyView()
        }.id(viewModel.backToArticle)

        VStack(alignment: .leading, spacing: 0) {
            CustomNaviBar(showBack: true, title: "Learn detail", backCall: dismissView, viewModel: viewModel)
                .padding(.horizontal, UIScreen.screenWidth*0.029)
                .padding(.top, UIScreen.screenHeight*0.0136)

            if quiz.imageLinks.count>1 {
                Image(quiz.imageLinks[1])
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.287)
                    .padding(.top, UIScreen.screenHeight*0.024)
            }

            VStack(alignment: .leading) {
                Text(quiz.subject)
                    .font(Font.custom("SFProDisplay-Regular", size: FontSize.title1))
                    .padding(.top, UIScreen.screenHeight*0.032)
                    .padding(.bottom, UIScreen.screenHeight*0.01)
                Text(quiz.description)
                    .font(Font.custom("SFProText-Regular", size: FontSize.body))
                                
                Spacer()
                
                ActionButton(text: "Start quiz", isLoading: $isLoading, action: {
                    if User.shared.isLoggin {
                        Task {
                            isLoading = true
                            await viewModel.fetchQuestion(quizId: String(quiz.id))
                            isLoading = false
                            viewModel.resetIndex()
                            starQuiz=true
                            // viewModel.incrementQuestionIndex()
                        }
                    } else {
                        showSignRedirect=true
                    }
                })
            }
            .frame(maxWidth: UIScreen.screenWidth*0.917)
            .padding(.bottom, UIScreen.screenHeight*0.021)
            .padding(.leading, UIScreen.screenWidth*0.034)
        }
        .navigationBarHidden(true)
        .foregroundColor(Color("#333333"))
    }
}

extension ArticleView {
    func dismissView() {
        dismiss()
    }
}

struct ArticleView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleView(
            quiz: QuizModel(
                id: 1,
                imageLinks: [""],
                description: "Blockchain is a distributed digital ledger...",
                subject: "What is a blockchain?",
                participationStatus: "dd"
            ),
            viewModel: LearnViewModel(),
            isLastQuiz: false
        )
    }
}

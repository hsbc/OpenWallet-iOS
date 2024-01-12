//
//  LearnView.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 5/24/22.
//

import SwiftUI

struct LearnView: View {
    @ObservedObject var user: User = User.shared
    @StateObject var viewModel = LearnViewModel()
    @State var quizLists: [QuizModel] = []
    @State var isShowLoading = true
    var body: some View {
        ZStack {
            if isShowLoading {
                ProgressView()
                    .scaleEffect(2)
                    .progressViewStyle(CircularProgressViewStyle(tint: .black))
            } else {
                ScrollView(showsIndicators: false) {
                    // This is a hack to force this view to refresh/rerender once condition changes
                    // in order to redirect back to this page when user is in the nested child view.
                    // TODO: find a better to replace this workaround. [weihao.zhang]
                    if user.isLoggin {
                        articles()
                    } else {
                        articles()
                    }
                }.padding(.bottom, UIScreen.main.bounds.height*0.01).padding(.top, 5)
            }

        }
        .navigationBarHidden(true)
        .task {
            await viewModel.fetchQuiz()
            isShowLoading = false
            quizLists=viewModel.quizLists
            OHLogInfo(quizLists)
        }
        .viewAppearLogger(self)
    }
}

extension LearnView {
    func articles() -> some View {
        Group {
            ForEach(quizLists.indices, id: \.self) { index in
                NavigationLink {
                    ArticleView(quiz: quizLists[index], viewModel: viewModel, isLastQuiz: index == quizLists.count-1)
                        .modifier(HideNavigationBar())
                } label: {
                    ActivityView(quiz: quizLists[index], index: index+1,
                                 isOpen: isOpen(index: index),
                                 isCompeleted: isCompleted(index: index)
                    ).padding(.bottom, 10)
                }
                .disabled(isDisable(index: index))
                .id(viewModel.backToLearn)
            }
        }
    }
    
    func isDisable(index: Int) -> Bool {
        // if the quiz index is not the first one, only when its last quiz was completed,it can be visited.
        return
            (index != 0 &&
             (quizLists[index-1].participationStatus == nil ||
              quizLists[index-1].participationStatus != "COMPLETED_SUCCESSFUL") ||
              quizLists[index].participationStatus == "COMPLETED_SUCCESSFUL"
            )
    }
    
    func isOpen(index: Int) -> Bool {
        // the first quiz always can be accessed.
        if index==0 {
            return true
        } else {
            if quizLists[index-1].participationStatus != nil
               && quizLists[index-1].participationStatus == "COMPLETED_SUCCESSFUL" {
                return true
            }
        }
        
        return false
            
    }
    
    func isCompleted(index: Int) -> Bool {
        return
            (quizLists[index].participationStatus != nil
             && quizLists[index].participationStatus == "COMPLETED_SUCCESSFUL")
    }
}

struct LearnView_Previews: PreviewProvider {
    static var previews: some View {
            LearnView(quizLists: [QuizModel(id: 1, imageLinks: ["cryptocurrency_learn_list_banner"], description: "asd", subject: "sad", participationStatus: "UNCOMPLETED_SUCCESSFUL"), QuizModel(id: 2, imageLinks: ["cryptocurrency_learn_list_banner"], description: "asd", subject: "sad", participationStatus: "UNCOMPLETED_SUCCESSFUL"), QuizModel(id: 3, imageLinks: ["cryptocurrency_learn_list_banner"], description: "asd", subject: "sad", participationStatus: "UNCOMPLETED_SUCCESSFUL")])
    }
}

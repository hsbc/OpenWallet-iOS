//
//  LearnViewModel.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/7/11.
//

import Foundation

class LearnViewModel: ObservableObject {
    @Published var quizLists: [QuizModel] = [QuizModel]()
    @Published var questionLists: [QuestionModel] = []
    @Published var backToArticle: Bool = false
    @Published var backToLearn: Bool = false
    var questionIndex = 0
    
    var activityId: String = ""
    
    let activityService: ActivityService
    let quizService: QuizService
    
    init(activityService: ActivityService = ActivityService(), quizService: QuizService = QuizService()) {
        self.activityService = activityService
        self.quizService = quizService
    }

    func incrementQuestionIndex() {
        questionIndex += 1
    }
    
    func resetIndex() {
        questionIndex = 0
    }
    
    @MainActor
    func fetchQuiz() async {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        do {

            if User.shared.token == "" {
                let luckydrawList: [ActivityModel] = try await activityService.getLuckyDrawActivity().data
                var lastModifyDate: Date = dateFormatter.date(from: "1900-01-01T00:00:00")!
                var activityID: Int = -1
                if luckydrawList.count > 0 {
                    // find the lastest and comitted activityID
                    for activity in luckydrawList {
                        if activity.lastModifiedTime != nil && activity.activityStatus == "COMMITTED" {
                            let date = dateFormatter.date(from: activity.lastModifiedTime!.components(separatedBy: ".")[0])!
                            if date > lastModifyDate {
                                lastModifyDate = date
                                activityID = activity.activityId
                            }
                        }
                    }
                    self.activityId = String(activityID)
                    quizLists = try await activityService.getQuiz(activityId).data
                }
            } else {
                
                // 1.get user's Activity List and select the first activity ID
                var activityList: [ActivityModel] = []
                activityList = try await activityService.getActivityByToken(User.shared.token).data
                
                // 2. get Quiz List by activity ID from last step
                if activityList.count>0 {
                    self.activityId = String(activityList[0].activityId)
                    quizLists = try await activityService.getQuizByToken(self.activityId, User.shared.token).data
                } else {
                    quizLists = []
                }
            }
            
        } catch {
            
        }

    }
    
    @MainActor
    func fetchQuestion(quizId: String) async {
        do {
            let result = try await quizService.getQuestion(quizId, User.shared.token)
            guard result.data != nil else { return }
            questionLists = result.data!
        } catch let error {
            OHLogInfo("fetchQuestion error:\(error)")
        }
    }

    @MainActor
    func verifyAnswer(questionId: String, answer: String) async -> Bool {
        var result: Bool
        do {
            let verifyResult = try await quizService.verifyAnswer(questionId, answer, User.shared.token)
            result = verifyResult.data
        } catch let error {
            result = false
            OHLogInfo("verifyAnswer error:\(error)")
        }
        return result
    }

    @MainActor
    func updateQuizState(quizId: String) async -> Bool {
        var flag = false
        do {
            let result = try await quizService.updateQuizStatus(quizId, User.shared.token)

            if result.message == "Status updated"{
                flag = true
            }
        } catch let error {
            OHLogInfo("updateQuizState error:\(error)")
        }
        return flag
    }
    
    @MainActor
    @discardableResult
    func isActivityFinished() async -> Bool {
        var isFinished: Bool
        
        do {
            try await activityService.isActivityFinished(self.activityId, User.shared.token)
            isFinished = true
        } catch {
            isFinished = false
        }
        
        return isFinished
    }

}

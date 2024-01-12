//
//  FAQView.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/7/20.
//

import SwiftUI

struct FAQView: View {
    @Environment(\.dismiss) var dismiss

    @ObservedObject var viewModel: ProfileViewModel

    @State var getFAQImmediately: Bool = true

    var body: some View {
        VStack(spacing: 0) {
            TopBarView(title: "FAQ", backAction: {
                viewModel.clearFAQ()
                dismiss()
            })
            .padding(.horizontal, UIScreen.screenWidth * 0.029)
            .padding(.top, UIScreen.screenHeight * 0.0136)

            if viewModel.isFetchingFAQ {
                LoadingIndicator()
            } else if viewModel.failedToLoadFAQ {
                failedToLoadFAQView()
            } else {
                VStack {
                    if viewModel.QACategories.isEmpty {
                        VStack {
                            Spacer()
                            Text("The page is empty!")
                                .font(Font.custom("SFProText-Regular", size: FontSize.info))
                            Spacer()
                        }
                    } else {
                        faqSection()
                    }
                }
                .frame(width: UIScreen.screenWidth)
                .overlay(alignment: .top) {
                    ToastNotification(
                        showToast: $viewModel.showFailedToFetchFAQWarningNotification,
                        message: $viewModel.failedToFetchFAQWarningMessage
                    )
                    .padding(.horizontal, UIScreen.screenWidth * 0.029)
                }
            }
            
            navigationLinks()
            
            Spacer()
        }
        .viewAppearLogger(self)
        .task {
            if getFAQImmediately {
                await viewModel.sortQA()
            }
        }
    }
}

extension FAQView {
    func faqSection() -> some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(Array(viewModel.QACategories), id: \.self) { catogory in
                    FAQCategoryGroup(category: catogory, faqModels: viewModel.QADict[catogory]!)
                }
            }
        }
    }
    
    func failedToLoadFAQView() -> some View {
        GeometryReader { geometry in
            List {
                SwipeDownToRefreshIndicator()
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .listRowSeparator(.hidden)
            }
            .listStyle(PlainListStyle())
            .refreshable {
                OHLogInfo("Refresh faq.")
                await viewModel.sortQA()
            }
        }
    }

    func navigationLinks() -> some View {
        Group {
            NavigationLink(
                destination: ErrorView {
                    VStack(spacing: 7) {
                        ActionButton(text: "Try again") {
                            getFAQImmediately = false
                            viewModel.navigateToErrorViewFromFAQ = false
                        }
                        
                        ActionButton(text: "Go back to home", isPrimaryButton: false) {
                            AppState.shared.selectedTab = .home
                            NavigationStateForProfile.shared.backToProfile = true
                        }
                    }
                }.modifier(HideNavigationBar()),
                isActive: $viewModel.navigateToErrorViewFromFAQ
            ) {
                EmptyView()
            }
            .accessibilityHidden(true)
        }
    }
    
}

struct FAQView_Previews: PreviewProvider {
    static var previews: some View {
        FAQView(viewModel: ProfileViewModel())
    }
}

struct FAQCategoryGroup: View {
    @State var category: String = ""
    @State var faqModels: [QAModel] = []
    
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                ForEach(faqModels, id: \.self) { qaModel in
                    FAQQuestionGroup(faqModel: qaModel)
                }
            }
        }
    }
}

struct FAQQuestionGroup: View {
    @State var faqModel: QAModel
    
    var body: some View {
        CustomDisclosureGroup {
            VStack {
                Text(faqModel.answer)
                    .foregroundColor(Color("#333333"))
                    .font(Font.custom("SFProText-Regular", size: FontSize.info))
                    .frame(minWidth: 100, maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 13)
                    .padding(.vertical, 31)
                Spacer(minLength: 0)
            }
            .frame(width: UIScreen.screenWidth)
            .frame(minHeight: 187)
            .background(Color("#f3f3f3"))
        } label: {
            Text(faqModel.question)
                .multilineTextAlignment(.leading)
                .font(Font.custom("SFProText-Regular", size: FontSize.body))
                .padding(.vertical, 16)
            
        }
    }
}

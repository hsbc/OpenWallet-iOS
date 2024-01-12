//
//  HomeView.swift
//  OpenWallet
//
//  Created by WEIHAO ZHANG on 5/24/22.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var user: User = User.shared
    @ObservedObject var viewModel = CardViewModel()
    @State var showAlert: Bool = false
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading) {
                    
                    if user.isLoggin {
                        Text("Welcome, \(User.shared.name)").font(.headline)
                    }
                    
                    GeometryReader { geometry in
                        CarouselView(numberOfImages: 2) {
                            Image("Carousel_1")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width)
                            
                            Image("Carousel_2")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width)
                            
                        }
                    }.frame(height: UIScreen.main.bounds.height*0.15, alignment: .center)
                    
                    // Cabon Project
                    ForEach(viewModel.projectsLists) { list in
                        CardBlockView(listModel: list, isShowBackground: true, showAlert: $showAlert).padding([.top, .bottom], UIScreen.main.bounds.height*0.03)
                    }

                    // User Carbom
                    userCarbonView()
                    
                    // New Items
                    ForEach(viewModel.itemLists) { list in
                        CardBlockView(listModel: list, showAlert: $showAlert).padding(.top, UIScreen.main.bounds.height*0.03)
                    }
                    
                }
                
            }
            .padding([.leading, .trailing], UIScreen.main.bounds.width*0.04)
            .viewAppearLogger(self)
            // Alert View
            if showAlert {
                VStack {
                    Image(systemName: "alarm").resizable()
                        .frame(width: UIScreen.main.bounds.width*0.1, height: UIScreen.main.bounds.height*0.05, alignment: .center)
                        .padding(.bottom, 10)
                        .opacity(0.6)
                    Text("Coming Soon!")
                        .font(.system(size: 20))
                        .opacity(0.6)
                    
                }.frame(width: UIScreen.main.bounds.width*0.45, height: UIScreen.main.bounds.height*0.14)
                .background(LinearGradient(gradient: Gradient(colors: [Color("#f2f2f2"), Color.white]), startPoint: .top, endPoint: .bottom))
                .cornerRadius(8)
                .onAppear {
                    // Dismiss launch after after certain duration time
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        showAlert = false
                    }
                }
                
            }
            
        }
    }
}

extension HomeView {
    func userCarbonView() -> some View {
        Group {
            HStack(alignment: .lastTextBaseline) {
                Text("Your carbon")
                    .font(.title2)

                Text("Coming soon!")
                    .font(.subheadline)
                    .foregroundColor(Color("#4eadad"))
                    .background(Color("#f2f2f2"))
            }
            HStack {
                Spacer()
                carbonItemView(amount: "22,790", catogory: "Carbon consumed(G)").background(Color("#f9f2f3")).cornerRadius(5)

                carbonItemView(amount: "2,370", catogory: "Carbon neutrality(G)").background(Color("#e5f2f2")).cornerRadius(5)

                Spacer()
            }
        }
    }
    
    func carbonItemView(amount: String, catogory: String) -> some View {
        
        VStack {
            Text(amount).font(.title2)
            Text(catogory).font(.subheadline).foregroundColor(Color("#486484"))
        }.frame(width: UIScreen.main.bounds.width*0.445, height: UIScreen.main.bounds.height*0.086)
        
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

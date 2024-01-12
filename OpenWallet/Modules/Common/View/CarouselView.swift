//
//  CarouselView.swift
//  OpenWallet
//
//  Created by 陈炳辉 on 2022/7/6.
//
import SwiftUI
import Combine

struct CarouselView<Content: View>: View {
    private var numberOfImages: Int
    private var content: Content
    @State var slideGesture: CGSize = CGSize.zero
    @State private var currentIndex: Int = 0
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    init(numberOfImages: Int, @ViewBuilder content: () -> Content) {
        self.numberOfImages = numberOfImages
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ZStack(alignment: .bottom) {
                    HStack(spacing: 0) {
                        self.content
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .leading)
                    .offset(x: CGFloat(self.currentIndex) * -geometry.size.width, y: 0)
                    .animation(.spring())
                    .onReceive(self.timer) { _ in
                        self.currentIndex = (self.currentIndex + 1) % (self.numberOfImages == 0 ? 1 : self.numberOfImages)
                    }
                    .gesture(DragGesture().onChanged { value in
                        self.slideGesture = value.translation}.onEnded { _ in
                        if self.slideGesture.width < -50 {
                            if self.currentIndex < self.numberOfImages - 1 {
                                withAnimation {
                                    self.currentIndex += 1
                                    UserDefaults.standard.set(self.currentIndex, forKey: "articlesIndex")
                                    UserDefaults.standard.synchronize()                                }
                            }
                        }
                        if self.slideGesture.width > 50 {
                            if self.currentIndex > 0 {
                                withAnimation {
                                    self.currentIndex -= 1
                                    UserDefaults.standard.set(self.currentIndex, forKey: "articlesIndex")
                                    UserDefaults.standard.synchronize()                                }
                            }
                        }
                        self.slideGesture = .zero
                    })
                }

                HStack(spacing: 8) {
                    ForEach(0..<self.numberOfImages, id: \.self) { index in
                        Circle()
                            .frame(width: index == self.currentIndex ? 8 : 6,
                                   height: index == self.currentIndex ? 8 : 6)
                            .foregroundColor(index == self.currentIndex ? Color("#000000"): Color("#d7d8d6") )
                            .animation(.spring())
                    }
                }.padding(.top, UIScreen.screenHeight * 0.02)

            }
        }
    }
}

struct CarouselView_Previews: PreviewProvider {
    static var previews: some View {
        
        // 8
        GeometryReader { geometry in
            CarouselView(numberOfImages: 2) {
                Image("Carousel_1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                Image("Carousel_2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.2, alignment: .center)
        .border(.red)
        
    }
}

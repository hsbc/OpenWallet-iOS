//
//  CarouselNew.swift
//  OpenWallet
//
//  Created by TQ on 2022/9/29.
//

import SwiftUI

enum LoopType {
    case none
    case reverse
    case round
}

struct CarouselNew: View {
    private var templates: [CarouselTemplate]
    private var horPadding: CGFloat
    private var horInset: CGFloat
    private var containerWidth: CGFloat
    private var containerHeight: CGFloat
    private var itemWidth: CGFloat
    private var itemHeight: CGFloat
    private var itemBackground: Color
    private var gestureThreshold: CGFloat
    private var indicatorHeight: CGFloat
    private var loopType: LoopType
    private var showArrow: Bool = true
    private var strokeLineWidth: CGFloat
    private var indicatorSelectedColor: Color = .black
    private var indicatorNormalColor: Color = .clear
    private var indicatorNormalSize: CGSize
    private var indicatorSelectedSize: CGSize
    private var indicatorTopPadding: CGFloat
    private var showIndicatorBackground: Bool = true
    private var changedIndexHandler: ((_ index: Int) -> Void)?
    
    @State private var dragOffset = 0.0
    @State private var currentIndex = 0
    
    // Timer
    private let timerDelayStart = 1.0
    @State private var timer = Timer.publish(every: 2, on: .current, in: .common).autoconnect()
    @State private var timerToRight = true
    
    func restartTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + timerDelayStart) {
            timer = Timer.publish(every: 2, on: .current, in: .common).autoconnect()
        }
    }
    
    func cancelTimer() {
        timer.upstream.connect().cancel()
    }
    
    init(_ templates: [CarouselTemplate],
         horPadding: CGFloat = 0.043 * UIScreen.screenWidth,
         horInset: CGFloat = 0.021 * UIScreen.screenWidth,
         containerWidth: CGFloat = UIScreen.screenWidth,
         containerHeight: CGFloat = 300,
         itemWidth: CGFloat = 0.914 * UIScreen.screenWidth,
         itemHeight: CGFloat = 0,
         gestureThreshold: CGFloat = 0.13 * UIScreen.screenWidth,
         itemBackground: Color = Color.gray.opacity(0.12),
         indicatorHeight: CGFloat = 44,
         loopType: LoopType = .none,
         showArrow: Bool = true,
         strokeLineWidth: CGFloat = 1,
         indicatorNormalColor: Color = .clear,
         indicatorSelectedColor: Color = .black,
         indicatorNormalSize: CGSize = CGSize(width: 8, height: 8),
         indicatorSelectedSize: CGSize = CGSize(width: 8, height: 8),
         indicatorTopPadding: CGFloat = 0,
         showIndicatorBackground: Bool = true,
         changedIndexHandler: ((_ index: Int) -> Void)? = nil) {
        self.templates = templates
        self.horPadding = horPadding
        self.horInset = horInset
        self.containerWidth = containerWidth
        self.containerHeight = containerHeight
        self.itemWidth = itemWidth
        self.itemHeight = itemHeight
        self.gestureThreshold = gestureThreshold
        self.itemBackground = itemBackground
        self.indicatorHeight = indicatorHeight
        self.loopType = loopType
        self.showArrow = showArrow
        self.strokeLineWidth = strokeLineWidth
        self.indicatorNormalColor = indicatorNormalColor
        self.indicatorSelectedColor = indicatorSelectedColor
        self.indicatorNormalSize = indicatorNormalSize
        self.indicatorSelectedSize = indicatorSelectedSize
        self.indicatorTopPadding = indicatorTopPadding
        self.showIndicatorBackground = showIndicatorBackground
        self.changedIndexHandler = changedIndexHandler
    }
    
    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { proxy in
                HStack(alignment: .center, spacing: horInset) {
                    ForEach(templates) {
                        $0.view.background(itemBackground)
                                .frame(width: itemWidth)
                    }
                }
                .offset(x: dragOffset - CGFloat(currentIndex) * (itemWidth + horInset))
                .gesture(dragGesture)
                .animation(.interactiveSpring(), value: dragOffset)
                .frame(width: proxy.size.width,
                       height: proxy.size.height,
                       alignment: .leading)
            }
            .frame(height: containerHeight - indicatorHeight)
            
            HStack {
                if showArrow {
                    Button(action: {
                        withAnimation {
                            moveIndicator(toLeft: true)
                            cancelTimer()
                            timerToRight = false
                            restartTimer()
                        }
                    }, label: {
                        withAnimation {
                            Image(systemName: "chevron.left")
                                .foregroundColor(isIndicatorReachHead() ? .gray.opacity(0.5) : .black)
                        }
                    })
                    .disabled(isIndicatorReachHead())
                }
                
                Spacer()
                
                HStack(spacing: 8) {
                    ForEach(0 ..< self.templates.count, id: \.self) { index in
                        withAnimation {
                            Circle()
                                .frame(width: index == currentIndex ? indicatorSelectedSize.width : indicatorNormalSize.width,
                                       height: index == currentIndex ? indicatorSelectedSize.height : indicatorNormalSize.height)
                                .foregroundColor(index == currentIndex ? indicatorSelectedColor : indicatorNormalColor)
                                .background(Circle().stroke(.black, lineWidth: strokeLineWidth))
                        }
                    }
                }
                
                Spacer()
                
                if showArrow {
                    Button(action: {
                        withAnimation {
                            moveIndicator(toLeft: false)
    
                            cancelTimer()
                            timerToRight = true
                            restartTimer()
                        }
                    }, label: {
                        withAnimation {
                            Image(systemName: "chevron.right")
                                .foregroundColor(isIndicatorReachTail() ? .gray.opacity(0.5) : .black)
                        }
                    })
                    .disabled(isIndicatorReachTail())
                }
            }
            .frame(height: indicatorHeight)
            .padding(.top, indicatorTopPadding)
        }
        .onReceive(timer, perform: { _ in
            withAnimation {
                switch self.loopType {
                case .reverse:
                    moveIndicator(toLeft: !timerToRight, autoReverse: true)
                case .round:
                    moveIndicatorRound()
                case .none:
                    break
                }
            }
        })
        .frame(height: containerHeight)
        .padding(.horizontal, horPadding)
        .accessibilityLabel("Carousel")
    }
}

extension CarouselNew {
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { changeValue in
                dragOffset = changeValue.translation.width
                
                cancelTimer()
            }
            .onEnded { endValue in
                dragOffset = .zero
                
                if endValue.translation.width > gestureThreshold {
                    moveIndicator(toLeft: true)
                    timerToRight = false
                }
                if endValue.translation.width < -gestureThreshold {
                    moveIndicator(toLeft: false)
                    timerToRight = true
                }
                
                restartTimer()
            }
    }
    
    private func moveIndicator(toLeft: Bool, autoReverse: Bool = false) {
        var change = currentIndex
        if toLeft {
            if autoReverse && isIndicatorReachHead() {
                timerToRight = !timerToRight
                change += 1
            } else {
                change -= 1
            }
        } else {
            if autoReverse && isIndicatorReachTail() {
                timerToRight = !timerToRight
                change -= 1
            } else {
                change += 1
            }
        }
        currentIndex = max(min(change, templates.count - 1), 0)
        notifyDidChangedIndex()
    }
    
    private func moveIndicatorRound() {
        currentIndex = (currentIndex + 1) % (templates.count == 0 ? 1 : templates.count)
        notifyDidChangedIndex()
    }
    
    private func isIndicatorReachHead() -> Bool {
        return currentIndex == 0
    }
    
    private func isIndicatorReachTail() -> Bool {
        return currentIndex == templates.count - 1
    }
    
    private func notifyDidChangedIndex() {
        guard let handler = changedIndexHandler else { return }
        handler(currentIndex)
    }
}

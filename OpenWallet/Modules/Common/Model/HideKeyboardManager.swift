//
//  HideKeyboardManager.swift
//  OpenWallet
//
//  Created by Jianrong Fan on 2022/10/13.
//

import SwiftUI
import Combine

class HideKeyboardManager: NSObject {
    
    static let shared = HideKeyboardManager()
    
    private var keyboardHideMonitor: AnyCancellable?
    private var keyboardShownMonitor: AnyCancellable?
    private var tapGesture: UITapGestureRecognizer?
    
    func startAutoDismissKeyboard() {
        addKeyboardNotification()
        addTapGestureRecognizer()
    }
    
    func stopAutoDismissKeyboard() {
        guard let window = keyWindow, let tapGesture = self.tapGesture else { return }
        window.removeGestureRecognizer(tapGesture)
        self.tapGesture = nil
    }
}

private extension HideKeyboardManager {
    func addKeyboardNotification() {
        keyboardShownMonitor = NotificationCenter.default
            .publisher(for: UIWindow.keyboardWillShowNotification)
            .sink { _ in
                OHLogInfo("keyboard will show")
                if let tapGesture = self.tapGesture, !tapGesture.isEnabled {
                    tapGesture.isEnabled = true
                }
            }
        
        keyboardHideMonitor = NotificationCenter.default
            .publisher(for: UIWindow.keyboardWillHideNotification)
            .sink { _ in
                OHLogInfo("keyboard will hide")
                if let tapGesture = self.tapGesture, tapGesture.isEnabled {
                    tapGesture.isEnabled = false
                }
            }
    }
    
    func addTapGestureRecognizer() {
        guard let window = keyWindow else { return }
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(resignCurrentResponder))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.isEnabled = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
        self.tapGesture = tapGesture
    }
    
    @objc func resignCurrentResponder() {
        OHLogInfo("tap to hide keyboard")
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
    
    var keyWindow: UIWindow? {
        // Get connected scenes
        return UIApplication.shared.connectedScenes
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
}

extension HideKeyboardManager: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith
                                  otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard var touchedView = touch.view else { return false }
        
        if shouldIgnore(view: touchedView) {
            return false
        }
        
        while let superview = touchedView.superview {
            if shouldIgnore(view: touchedView) {
                return false
            }
            touchedView = superview
        }
        
        return true
    }
    
    func shouldIgnore(view: UIView) -> Bool {
        if view is UIControl || view is UITextField || view is UITextView {
            return true
        }
        return false
    }
}

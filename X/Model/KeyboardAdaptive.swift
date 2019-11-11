//
//  KeyboardAdaptive.swift
//  X
//
//  Created by xhd2015 on 2019/11/11.
//  Copyright © 2019 snu2017. All rights reserved.
//
import Combine
import SwiftUI

// usage: .modifier(AdaptsToSoftwareKeyboard())
struct KeyboardAdaptive: ViewModifier {

    @State var currentHeight: CGFloat = 0

    func body(content: Content) -> some View {
//        Group{
//            Text("height:\(self.currentHeight)")
        content
            .padding(.bottom, self.currentHeight)
            .edgesIgnoringSafeArea(self.currentHeight == 0 ? Edge.Set() : .bottom)
            .onAppear(perform: subscribeToKeyboardEvents)
//        }
    }

    private let keyboardWillOpen = NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillShowNotification)
        .map { $0.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect }
        .map { $0.height }

    private let keyboardWillHide =  NotificationCenter.default
        .publisher(for: UIResponder.keyboardWillHideNotification)
        .map { _ in CGFloat.zero }

    private func subscribeToKeyboardEvents() {
        _ = Publishers.Merge(keyboardWillOpen, keyboardWillHide)
            .subscribe(on: RunLoop.main)
            .assign(to: \.self.currentHeight, on: self)
    }
}

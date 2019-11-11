//
//  KeyboardHeight.swift
//  X
//
//  Created by xhd2015 on 2019/11/11.
//  Copyright © 2019 snu2017. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit
// not work when injected
//extension EnvironmentValues {
//
//  var keyboardHeight : CGFloat {
//    get { EnvironmentObserver.shared.keyboardHeight }
//  }
//
//}
//
//class EnvironmentObserver {
//
//  static let shared = EnvironmentObserver()
//
//  var keyboardHeight: CGFloat = 0 {
//    didSet { print("Keyboard height \(keyboardHeight)") }
//  }
//
//  init() {
//
//    // MARK: Keyboard Events
//
//    NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidHideNotification, object: nil, queue: OperationQueue.main) { [weak self ] (notification) in
//      self?.keyboardHeight = 0
//    }
//
//    let handler: (Notification) -> Void = { [weak self] notification in
//        guard let userInfo = notification.userInfo else { return }
//        guard let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
//
//        // From Apple docs:
//        // The rectangle contained in the UIKeyboardFrameBeginUserInfoKey and UIKeyboardFrameEndUserInfoKey properties of the userInfo dictionary should be used only for the size information it contains. Do not use the origin of the rectangle (which is always {0.0, 0.0}) in rectangle-intersection operations. Because the keyboard is animated into position, the actual bounding rectangle of the keyboard changes over time.
//
//        self?.keyboardHeight = frame.size.height
//    }
//
//    NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidShowNotification, object: nil, queue: OperationQueue.main, using: handler)
//
//    NotificationCenter.default.addObserver(forName: UIResponder.keyboardDidChangeFrameNotification, object: nil, queue: OperationQueue.main, using: handler)
//
//  }
//}

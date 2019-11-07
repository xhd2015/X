//
//  TextView.swift
//  X
//
//  Created by xhd2015 on 2019/11/3.
//  Copyright © 2019 snu2017. All rights reserved.
//
import Foundation
import SwiftUI

struct TextView: UIViewRepresentable {
    @Binding var text: String
    var editable:Bool = true

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> UITextView {

        let myTextView = UITextView()
        myTextView.delegate = context.coordinator

        myTextView.font = UIFont(name: "HelveticaNeue", size: 15)
        myTextView.isScrollEnabled = true
        myTextView.isEditable = self.editable
        myTextView.isUserInteractionEnabled = true
        myTextView.backgroundColor = UIColor(white: 0.0, alpha: 0.05)
        
        return myTextView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }

    class Coordinator : NSObject, UITextViewDelegate {

        var parent: TextView

        init(_ uiTextView: TextView) {
            self.parent = uiTextView
        }

        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            return true
        }

        func textViewDidChange(_ textView: UITextView) {
//            print("text now: \(String(describing: textView.text!))")
            self.parent.text = textView.text
        }
    }
}


struct TextView_Previews: PreviewProvider {
    @State static var text = "hello"
    static var previews: some View {
        TextView(text: self.$text,editable: true)
            .frame(height:200)
    }
}

//
//  CustomTextView.swift
//  Vinishko
//
//  Created by mttm on 22.05.2023.
//

import UIKit

class CustomTextView: UITextView {
    
    weak var resizableHeightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        isScrollEnabled = false
        delegate = self
        layer.borderWidth = 0.7
        layer.borderColor = UIColor(red: 0.9098039269, green: 0.9098039269, blue: 0.9098039269, alpha: 1).cgColor
        layer.cornerRadius = 5.0
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        isScrollEnabled = false
        delegate = self
        layer.borderWidth = 0.7
        layer.borderColor = UIColor(red: 0.9098039269, green: 0.9098039269, blue: 0.9098039269, alpha: 1).cgColor
        layer.cornerRadius = 5.0
    }
    
    func setup(_ constraint: NSLayoutConstraint) {
        resizableHeightConstraint = constraint
    }
}

extension CustomTextView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == LocalizableText.enterComment {
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = LocalizableText.enterComment
            textView.textColor = #colorLiteral(red: 0.7764703631, green: 0.7764707804, blue: 0.7850785851, alpha: 1)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        resizableHeightConstraint?.constant = newSize.height
        layoutIfNeeded()
    }
}

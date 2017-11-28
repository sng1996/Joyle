//
//  UITextViewPlaceholder.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 26.11.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class UITextViewPlaceholder: UITextView, UITextViewDelegate {
    
    override public var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.characters.count > 0
        }
        let textViewFixedWidth: CGFloat = textView.frame.size.width
        let newSize: CGSize = textView.sizeThatFits(CGSize(width: textViewFixedWidth, height: CGFloat(MAXFLOAT)))
        var newFrame: CGRect = textView.frame
        let heightDifference = textView.frame.height - newSize.height
        if (abs(heightDifference) > 1) {
            newFrame.size = CGSize(width: fmax(newSize.width, textViewFixedWidth), height: newSize.height)
            newFrame.offsetBy(dx: 0.0, dy: heightDifference)
            updateParentView(heightDifference: heightDifference, view: textView.superview!, textView: textView)
        }
        textView.frame = newFrame
    }
    
    func updateParentView(heightDifference: CGFloat, view: UIView, textView: UITextView) {
        view.subviews[1].frame.origin.y -= heightDifference
        view.subviews[2].frame.origin.y -= heightDifference
        view.frame.size.height -= heightDifference
        view.superview!.frame.size.height -= heightDifference
        view.superview!.subviews[2].frame.origin.y -= heightDifference
        let cV = view.superview!.superview!.subviews[0] as? UICollectionView
        if ((view.superview!.frame.origin.y + view.superview!.frame.size.height) > (568 - 250)){
            textView.inputAccessoryView?.isHidden = false
            textView.reloadInputViews()
            cV?.contentOffset.y += heightDifference
            view.superview!.frame.origin.y += heightDifference
        }
        if (view.superview!.frame.origin.y < 20){
            view.superview!.frame.origin.y = 20
            view.superview!.layer.shadowOpacity = 0.0
            let scrollView = view as! UIScrollView
            scrollView.contentOffset.y -= heightDifference
        }
    }
    
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor(red: 158/255.0, green: 171/255.0, blue: 205/255.0, alpha: 1.0)
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = self.text.characters.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
    
}

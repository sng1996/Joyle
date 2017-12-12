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
        
        new_updateMoreView(heightDifference: heightDifference, view: view, textView: textView)
        
    }
    
    func new_updateMoreView(heightDifference: CGFloat, view: UIView, textView: UITextView){
        let scrollView = view as! UIScrollView
        moveObjectsInsideScrollView(heightDifference: heightDifference, view: view, textView: textView)
        /*if (isFitBetweenYAndKeyboard(heightDifference: heightDifference, view: view, textView: textView)){
            scrollView.frame.size.height = scrollView.contentSize.height
            moveObjectsInsideMoreView(heightDifference: heightDifference, view: view, textView: textView)
            textView.inputAccessoryView?.isHidden = true
            textView.reloadInputViews()
        }
        else if(isFitBetweenTopAndKeyboard(heightDifference: heightDifference, view: view, textView: textView)){
            let inputView: CGFloat = 44.0
            let keyboardY = (view.superview?.superview?.frame.size.height)! - CGFloat(textView.tag) - inputView
            scrollView.frame.size.height = scrollView.contentSize.height
            moveObjectsInsideMoreView(heightDifference: heightDifference, view: view, textView: textView)
            view.superview?.frame.origin.y = keyboardY - ((view.superview?.frame.size.height)! - (view.superview?.subviews[2].frame.size.height)!)
            textView.inputAccessoryView?.isHidden = false
            textView.reloadInputViews()
        }
        else{*/
            let gap: CGFloat = 5.0
            let inputView: CGFloat = 44.0
            scrollView.frame.size.height = (view.superview?.superview?.frame.size.height)! - CGFloat(textView.tag) - inputView - gap - 20.0 - scrollView.frame.origin.y
            moveObjectsInsideMoreView(heightDifference: heightDifference, view: view, textView: textView)
            view.superview?.frame.origin.y = 20.0
            textView.inputAccessoryView?.isHidden = false
            textView.reloadInputViews()
        //}
        
    }
    
    func realHeight(heightDifference: CGFloat, view: UIView, textView: UITextView) -> CGFloat{
        
        let gap: CGFloat = 5.0
        let scrollView = view as! UIScrollView
        if (scrollView.contentSize.height < 35.0){
            scrollView.contentSize.height = 35.0
        }
        
        let moreViewH = (view.superview?.subviews[0].frame.size.height)! + gap + scrollView.contentSize.height + 2*gap + (view.superview?.subviews[2].frame.size.height)!
        return moreViewH
        
    }
    
    func moveObjectsInsideScrollView(heightDifference: CGFloat, view: UIView, textView: UITextView){
        
        let gap: CGFloat = 5.0
        view.subviews[1].frame.origin.y = view.subviews[0].frame.origin.y + view.subviews[0].frame.size.height - heightDifference + gap //tagsView
        view.subviews[2].frame.origin.y = view.subviews[1].frame.origin.y + view.subviews[1].frame.size.height + gap// tV
        let scrollView = view as! UIScrollView
        scrollView.contentSize.height = view.subviews[0].frame.size.height - heightDifference + gap + view.subviews[1].frame.size.height + gap + view.subviews[2].frame.size.height + 2*gap //scrollView
        
    }
    
    func moveObjectsInsideMoreView(heightDifference: CGFloat, view: UIView, textView: UITextView){
        
        let gap: CGFloat = 5.0
        let scrollView = view as! UIScrollView
        scrollView.frame.origin.y = (view.superview?.subviews[0].frame.origin.y)! + (view.superview?.subviews[0].frame.size.height)! + gap
        view.superview?.subviews[2].frame.origin.y = scrollView.frame.origin.y + scrollView.frame.size.height + 2*gap
        view.superview?.frame.size.height = (view.superview?.subviews[2].frame.origin.y)! + (view.superview?.subviews[2].frame.size.height)!
        
    }
    
    func isFitBetweenYAndKeyboard(heightDifference: CGFloat, view: UIView, textView: UITextView) -> Bool{
        
        let realH: CGFloat = realHeight(heightDifference: heightDifference, view: view, textView: textView)
        let gap = (view.superview?.superview?.frame.size.height)! - CGFloat(textView.tag) - 5.0 - (view.superview?.frame.origin.y)!
        return (gap > realH)
    }
    
    func isFitBetweenTopAndKeyboard(heightDifference: CGFloat, view: UIView, textView: UITextView) -> Bool{

        let realH: CGFloat = realHeight(heightDifference: heightDifference, view: view, textView: textView)
        
        let gap = (view.superview?.superview?.frame.size.height)! - CGFloat(textView.tag) - 5.0 - 20.0
        if (heightDifference > 0){
            return (gap > realH)
        }
        return ((view.superview?.frame.origin.y)! > CGFloat(20.0))
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

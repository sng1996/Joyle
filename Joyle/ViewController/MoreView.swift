//
//  MoreView.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 26.11.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

extension ViewController{

    func realHeight() -> CGFloat{
        
        let gap: CGFloat = 5.0
        
        //fix bug where scrollView.contentSize.height < empty more_note
        if (more_scrollView.contentSize.height < 35.0){
            more_scrollView.contentSize.height = 35.0
        }
        
        let moreViewH = more_titleView.frame.size.height + gap + more_scrollView.contentSize.height + 2*gap + more_iconsView.frame.size.height
        return moreViewH
        
    }
    
    func moveObjectsInsideScrollView(){
        
        let gap: CGFloat = 5.0
        more_tagsView.frame.origin.y = more_note.frame.origin.y + more_note.frame.size.height + gap
        more_tV.frame.origin.y = more_tagsView.frame.origin.y + more_tagsView.frame.size.height + gap
        more_scrollView.contentSize.height = more_note.frame.size.height + gap + more_tagsView.frame.size.height + gap + more_tV.frame.size.height + 2*gap
        
    }
    
    func moveObjectsInsideMoreView(){
        
        let gap: CGFloat = 5.0
        more_scrollView.frame.origin.y = more_titleView.frame.origin.y + more_titleView.frame.size.height + gap
        more_iconsView.frame.origin.y = more_scrollView.frame.origin.y + more_scrollView.frame.size.height + 2*gap
        moreView.frame.size.height = more_iconsView.frame.origin.y + more_iconsView.frame.size.height
        
    }
    
    func isFitBetweenTopAndKeyboard(keyboardH: CGFloat) -> Bool{
        
        let realH: CGFloat = realHeight()
        
        let gap = self.view.frame.size.height - keyboardH - topMargin
        if (cellH > 0){
            return (gap > realH)
        }
        return (moreView.frame.origin.y > topMargin)
        
    }
    
    func isFitBetweenYAndKeyboard(keyboardH: CGFloat) -> Bool{
        
        let realH: CGFloat = realHeight()
        let gap = self.view.frame.size.height - keyboardH - moreView.frame.origin.y
        return (gap > realH)
        
    }
    
    func isFitBetweenTopAndBottom() -> Bool{
        
        let realH: CGFloat = realHeight()
        let gap = self.view.frame.size.height - bottomMargin - topMargin
        return (gap > realH)
        
    }
    
    func isFitBetweenYAndBottom() -> Bool{
        
        let realH: CGFloat = realHeight()
        let gap = self.view.frame.size.height - bottomMargin - moreView.frame.origin.y
        return (gap > realH)
        
    }
    
    func openMoreView(){
        
        blackView.isHidden = false
        new_updateMoreView()
        
    }
    
    func openKeyboard(keyboardH: CGFloat){
        
        new_updateMoreView()
        
    }
    
    func closeKeyboard(){
        
        new_updateMoreView()
        
    }
    
    func createTagsView(){
        
        for view in more_tagsView.subviews {
            view.removeFromSuperview()
        }
        more_tagsView.frame.size.height = 0.0
        var currentX: CGFloat = 0.0
        var currentY: CGFloat = 0.0
        
        for i in 0..<tags.count{
            
            let tag = UIButton()
            tag.setTitle(tags[i], for: .normal)
            tag.titleLabel?.font = UIFont(name: "MuseoSansCyrl-300", size: 12)
            tag.setTitleColor(UIColor(red: 67/255.0, green: 191/255.0, blue: 128/255.0, alpha: 1.0), for: .normal)
            tag.layer.borderWidth = 1.0
            tag.layer.borderColor = UIColor(red: 67/255.0, green: 191/255.0, blue: 128/255.0, alpha: 1.0).cgColor
            tag.layer.cornerRadius = 5
            let maxSize = CGSize(width: 256, height: 100)
            let size = tag.titleLabel?.sizeThatFits(maxSize)
            tag.frame.size.height = 24.0
            tag.frame.size.width = (size?.width)! + 10.0
            if (more_tagsView.frame.size.width - currentX > tag.frame.size.width){
                tag.frame.origin.x = currentX
                tag.frame.origin.y = currentY
                currentX = currentX + 5.0 + tag.frame.size.width
            }
            else{
                currentY = currentY + tag.frame.size.height + 5.0
                tag.frame.origin.x = 0.0
                tag.frame.origin.y = currentY
                currentX = tag.frame.size.width + 5.0
            }
            
            more_tagsView.addSubview(tag)
            
        }
        
        more_tagsView.frame.size.height = currentY + 24.0 + 5.0
        new_updateMoreView()
        
    }
    
    func addCheckList(){
        
        more_tV.isHidden = false
        more_tV.reloadData()
        new_updateMoreView()
        
    }
    
    func clickCheckPoint(sender: UIButton){
        
        let cell = sender.superview?.superview as! MoreCell
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: cell.label.text!)
        attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
        cell.label.attributedText = attributeString
        cell.checkButton.setImage(UIImage(named: "round_gray"), for: .normal)
        
    }
    
    func addCheckPoint(textField: UITextField){
        
        checkPoints.append(textField.text!)
        more_tV.insertRows(at: [IndexPath(row: checkPoints.count-1, section: 0)], with: .bottom)
        textField.text = ""
        new_updateMoreView()
    }
    
    func deleteCheckPoint(indexPath: IndexPath){
        
        checkPoints.remove(at: indexPath.row)
        more_tV.deleteRows(at: [indexPath], with: .left)
        new_updateMoreView()
        
    }
    
    func new_updateMoreView(){
    
        moveObjectsInsideScrollView()
        if (isKeyboardOpen){
            
            if (isFitBetweenYAndKeyboard(keyboardH: CGFloat(myKeyboardHeight))){
                more_scrollView.frame.size.height = more_scrollView.contentSize.height
                moveObjectsInsideMoreView()
                tV_textField.inputAccessoryView?.isHidden = true
                tV_textField.reloadInputViews()
            }
            else if(isFitBetweenTopAndKeyboard(keyboardH: CGFloat(myKeyboardHeight))){
                let inputView: CGFloat = 44.0
                let keyboardY = self.view.frame.size.height - CGFloat(myKeyboardHeight) - inputView
                more_scrollView.frame.size.height = more_scrollView.contentSize.height
                moveObjectsInsideMoreView()
                moreView.frame.origin.y = keyboardY - (moreView.frame.size.height - more_iconsView.frame.size.height)
                tV_textField.inputAccessoryView?.isHidden = false
                tV_textField.reloadInputViews()
            }
            else{
                let gap: CGFloat = 5.0
                let inputView: CGFloat = 44.0
                more_scrollView.frame.size.height = self.view.frame.size.height - CGFloat(myKeyboardHeight) - inputView - gap - topMargin - more_scrollView.frame.origin.y
                moveObjectsInsideMoreView()
                moreView.frame.origin.y = topMargin
                tV_textField.inputAccessoryView?.isHidden = false
                tV_textField.reloadInputViews()
            }
            
        }
        else{
            
            if (isFitBetweenYAndBottom()){
                more_scrollView.frame.size.height = more_scrollView.contentSize.height
                moveObjectsInsideMoreView()
            }
            else if(isFitBetweenTopAndKeyboard(keyboardH: CGFloat(myKeyboardHeight))){
                more_scrollView.frame.size.height = more_scrollView.contentSize.height
                moveObjectsInsideMoreView()
                moreView.frame.origin.y = self.view.frame.size.height - bottomMargin - moreView.frame.size.height
            }
            else{
                let gap: CGFloat = 5.0
                more_scrollView.frame.size.height = self.view.frame.size.height - bottomMargin - more_iconsView.frame.size.height - gap - topMargin - more_scrollView.frame.origin.y
                moveObjectsInsideMoreView()
                moreView.frame.origin.y = topMargin
            }
            
        }
        
    }
    

}

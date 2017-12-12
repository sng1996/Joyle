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
        more_scrollView.contentSize.height = more_note.frame.size.height + gap + more_tagsView.frame.size.height + gap + more_tV.frame.size.height + 10*gap
        
    }
    
    func moveObjectsInsideMoreView(){
        
        let gap: CGFloat = 5.0
        more_scrollView.frame.origin.y = more_titleView.frame.origin.y + more_titleView.frame.size.height + gap
        more_iconsView.frame.origin.y = more_scrollView.frame.origin.y + more_scrollView.frame.size.height + 2*gap
        moreView.frame.size.height = more_iconsView.frame.origin.y + more_iconsView.frame.size.height
        
    }
    
    func isFitBetweenTopAndBottom() -> Bool{
        
        let realH: CGFloat = realHeight()
        let gap = self.view.frame.size.height - bottomMargin - topMargin
        return (gap > realH)
        
    }
    
    func openMoreView(){
        
        //blackButton_moreView.isHidden = false
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
    
    func adaptScrollView(){
        let gap: CGFloat = 5.0
        more_scrollView.frame.size.height = moreView.frame.size.height - 2*gap - more_iconsView.frame.size.height
    }
    
    func setCenter(){
        more_scrollView.frame.size.height = more_scrollView.contentSize.height
        moveObjectsInsideMoreView()
        let viewCenterY = (self.view.frame.size.height - bottomMargin - topMargin)/2.0 + topMargin
        let moreViewCenterY = moreView.frame.size.height/2.0
        moreView.frame.origin.y = viewCenterY - moreViewCenterY
    }
    
    func setTopKeyboard(){
        moreView.frame.size.height = self.view.frame.size.height - CGFloat(myKeyboardHeight) + 2.0 - topMargin
        adaptScrollView()
        more_iconsView.frame.origin.y = moreView.frame.size.height - more_iconsView.frame.size.height
        moreView.frame.origin.y = topMargin
    }
    
    func setTopBottom(){
        moreView.frame.size.height = self.view.frame.size.height - bottomMargin - topMargin
        adaptScrollView()
        more_iconsView.frame.origin.y = moreView.frame.size.height - more_iconsView.frame.size.height
        moreView.frame.origin.y = topMargin
    }
    
    
    
    func new_updateMoreView(){
    
        moveObjectsInsideScrollView()
        if (isKeyboardOpen){
            
            setTopKeyboard()
            tV_textField.inputAccessoryView?.isHidden = false
            tV_textField.reloadInputViews()
            
        }
        else{
            
            if (isFitBetweenTopAndBottom()){
                setCenter()
            }
            else{
                setTopBottom()
            }
            
        }
        
    }
    

}

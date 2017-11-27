//
//  TaskCell.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 06.09.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class TaskCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    @IBOutlet var label: UILabel!
    @IBOutlet var checkButton: UIButton!
    @IBOutlet var arrowButton: UIButton!
    @IBOutlet var plusImageView: UIImageView!
    var pan: UIPanGestureRecognizer!
    var deleteBtn: UIButton!
    var editBtn: UIButton!
    var calendarImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.contentView.backgroundColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.contentView.layer.cornerRadius = 4
        self.backgroundColor = UIColor.init(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1.0)
        self.layer.cornerRadius = 4
        
        calendarImageView = UIImageView(frame: CGRect(x:272,y:12,width:18,height:16))
        calendarImageView.image = UIImage(named: "calendar_gray")
        self.insertSubview(calendarImageView, belowSubview: self.contentView)
        
        /*deleteBtn = UIButton(frame: CGRect(x:0,y:0,width:50,height:50))
        deleteBtn.backgroundColor = UIColor.red
        deleteBtn.setTitle("Del", for: .normal)
        deleteBtn.setTitleColor(UIColor.white, for: .normal)
        deleteBtn.addTarget(self, action: #selector(deleteTask), for: UIControlEvents.touchUpInside)
        self.insertSubview(deleteBtn, belowSubview: self.contentView)
        
        editBtn = UIButton(frame: CGRect(x:50,y:0,width:50,height:50))
        editBtn.backgroundColor = UIColor.blue
        editBtn.setTitle("Edit", for: .normal)
        editBtn.setTitleColor(UIColor.white, for: .normal)
        editBtn.addTarget(self, action: #selector(editTask), for: UIControlEvents.touchUpInside)
        self.insertSubview(editBtn, belowSubview: self.contentView)*/
        
        pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        pan.delegate = self
        self.addGestureRecognizer(pan)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        if (pan.state == UIGestureRecognizerState.changed) {
            let p: CGPoint = pan.translation(in: self)
            let width = self.contentView.frame.width
            let height = self.contentView.frame.height
            self.contentView.frame = CGRect(x: p.x,y: 0, width: width, height: height);
            //self.deleteBtn.frame = CGRect(x: p.x - 2*deleteBtn.frame.size.width, y: 0, width: 50, height: height)
            //self.editBtn.frame = CGRect(x: p.x - editBtn.frame.size.width, y: 0, width: 50, height: height)
            //self.editBtn.frame = CGRect(x: p.x + width + editBtn.frame.size.width, y: 0, width: 50, height: height)*/
        }
        
    }

    func onPan(_ pan: UIPanGestureRecognizer) {
        
        if pan.state == UIGestureRecognizerState.began {
            
        } else if pan.state == UIGestureRecognizerState.changed {
            self.setNeedsLayout()
        } else {
            if pan.velocity(in: self).x > 500 {
                /*let collectionView: UICollectionView = self.superview as! UICollectionView
                let indexPath: IndexPath = collectionView.indexPathForItem(at: self.center)!
                collectionView.delegate?.collectionView!(collectionView, performAction: #selector(onPan(_:)), forItemAt: indexPath, withSender: 1)*/
            } else if pan.velocity(in: self).x < -500{
                let collectionView: UICollectionView = self.superview as! UICollectionView
                let indexPath: IndexPath = collectionView.indexPathForItem(at: self.center)!
                self.setNeedsLayout()
                self.layoutIfNeeded()
                collectionView.delegate?.collectionView!(collectionView, performAction: #selector(self.onPan(_:)), forItemAt: indexPath, withSender: 2)
            }
            else{
                
                UIView.animate(withDuration: 0.2, animations: {
                    if (self.contentView.frame.origin.x < 0 && self.contentView.frame.origin.x > -100){
                        self.setNeedsLayout()
                        self.layoutIfNeeded()
                    }
                    else{
                        let collectionView: UICollectionView = self.superview as! UICollectionView
                        let indexPath: IndexPath = collectionView.indexPathForItem(at: self.center)!
                        self.setNeedsLayout()
                        self.layoutIfNeeded()
                        collectionView.delegate?.collectionView!(collectionView, performAction: #selector(self.onPan(_:)), forItemAt: indexPath, withSender: 2)
                    }
                })
                
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return abs((pan.velocity(in: pan.view)).x) > abs((pan.velocity(in: pan.view)).y)
    }
    
    /*func deleteTask(){
        
        let collectionView: UICollectionView = self.superview as! UICollectionView
        let indexPath: IndexPath = collectionView.indexPathForItem(at: self.center)!
        collectionView.delegate?.collectionView!(collectionView, performAction: #selector(deleteTask), forItemAt: indexPath, withSender: 3)
        
    }
    
    func editTask(){
        let collectionView: UICollectionView = self.superview as! UICollectionView
        let indexPath: IndexPath = collectionView.indexPathForItem(at: self.center)!
        collectionView.delegate?.collectionView!(collectionView, performAction: #selector(editTask), forItemAt: indexPath, withSender: 4)
    }*/
}

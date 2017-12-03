//
//  MoreCell.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 26.11.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class MoreCell: UITableViewCell{

    @IBOutlet var checkButton: UIButton!
    @IBOutlet var label: UILabel!
    var calendarImageView: UIImageView!
    var pan: UIPanGestureRecognizer!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        self.contentView.backgroundColor = UIColor.init(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.contentView.layer.cornerRadius = 4
        self.backgroundColor = UIColor.init(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1.0)
        self.layer.cornerRadius = 4
        
        calendarImageView = UIImageView(frame: CGRect(x:257,y:7,width:13,height:15))
        calendarImageView.image = UIImage(named: "garbage")
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

            } else if pan.velocity(in: self).x < -500{
                let tableView: UITableView = self.superview as! UITableView
                let indexPath: IndexPath = tableView.indexPathForRow(at: self.center)!
                self.setNeedsLayout()
                self.layoutIfNeeded()
                tableView.delegate?.tableView!(tableView, performAction: #selector(self.onPan(_:)), forRowAt: indexPath, withSender: 1)
            }
            else{
                
                UIView.animate(withDuration: 0.2, animations: {
                    if (self.contentView.frame.origin.x < 0 && self.contentView.frame.origin.x > -100){
                        self.setNeedsLayout()
                        self.layoutIfNeeded()
                    }
                    else{
                        let tableView: UITableView = self.superview as! UITableView
                        let indexPath: IndexPath = tableView.indexPathForRow(at: self.center)!
                        self.setNeedsLayout()
                        self.layoutIfNeeded()
                        tableView.delegate?.tableView!(tableView, performAction: #selector(self.onPan(_:)), forRowAt: indexPath, withSender: 1)
                    }
                })
                
            }
        }
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return abs((pan.velocity(in: pan.view)).x) > abs((pan.velocity(in: pan.view)).y)
    }
    

}

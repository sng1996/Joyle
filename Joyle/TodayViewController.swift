//
//  TodayViewController.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 16.09.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class TodayViewController: UIViewController {

    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    @IBOutlet var cV: UICollectionView!
    
    var cvTodays: [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleLongGesture(_ gesture: UILongPressGestureRecognizer) {
        
        
        switch(gesture.state) {
            
        case UIGestureRecognizerState.began:
            
            guard let selectedIndexPath = cV.indexPathForItem(at: gesture.location(in: cV)) else {
                break
            }
            
            cV.beginInteractiveMovementForItem(at: selectedIndexPath)
            
        case UIGestureRecognizerState.changed:
            
            cV.updateInteractiveMovementTargetPosition(gesture.location(in: cV))
            
        case UIGestureRecognizerState.ended:
            
            cV.endInteractiveMovement()
            cV.reloadData()
            
        default:
            cV.cancelInteractiveMovement()
        }
        
    }
    
    
}

extension TodayViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = CGSize(width: collectionView.bounds.width, height: 50)
        return itemSize
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cvTodays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TaskCell
        
        cell.label.text = cvTodays[indexPath.row].name
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let tmpTask = cvTodays.remove(at: sourceIndexPath.row)
        cvTodays.insert(tmpTask, at: destinationIndexPath.row)
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    internal func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        var edgeInsets = UIEdgeInsets()
        edgeInsets = UIEdgeInsetsMake(5,5,5,5)
        return edgeInsets;
        
    }
    
}


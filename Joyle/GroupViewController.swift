//
//  GroupViewController.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 16.09.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController {
    
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    @IBOutlet var cV: UICollectionView!
    @IBOutlet var txtFld: UITextField!
    @IBOutlet var ok: UIBarButtonItem!
    
    var tmpIndexPath: IndexPath!
    var cvGroups: [Task] = []
    var isGroupEdit: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        for i in 1...5{
            let task = Task(name: "Group " + String(i))
            cvGroups.append(task)
        }
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(_:)))
        cV.addGestureRecognizer(longPressGesture)
        
        ok.title = ""
        
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

extension GroupViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = CGSize(width: collectionView.bounds.width, height: 50)
        return itemSize
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cvGroups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "groupCell", for: indexPath) as! GroupCell
        
        cell.textField.isUserInteractionEnabled = false
        cell.textField.text = cvGroups[indexPath.row].name
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let tmpTask = cvGroups.remove(at: sourceIndexPath.row)
        cvGroups.insert(tmpTask, at: destinationIndexPath.row)
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    internal func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        
        let flag = sender as! Int
        if (flag == 3){
            cvGroups.remove(at: indexPath.row)
            cV.deleteItems(at: [indexPath])
        }
        else if (flag == 2){
            let cell = collectionView.cellForItem(at: indexPath) as! GroupCell
            cell.textField.isUserInteractionEnabled = true
            cell.textField.becomeFirstResponder()
            UIView.animate(withDuration: 0.2, animations: {
                cell.setNeedsLayout()
                cell.layoutIfNeeded()
            })

            tmpIndexPath = indexPath
            isGroupEdit = true
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        var edgeInsets = UIEdgeInsets()
        edgeInsets = UIEdgeInsetsMake(5,5,5,5)
        return edgeInsets;
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        ok.title = "Готово"
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        ok.title = ""
        return true
    }
    
    @IBAction func pressOkButton(){
        
        if (isGroupEdit){
            let cell = cV.cellForItem(at: tmpIndexPath) as! GroupCell
            cell.textField.isUserInteractionEnabled = false
            cell.textField.resignFirstResponder()
            cvGroups[tmpIndexPath.row].name = cell.textField.text
            isGroupEdit = false
        }
        else{
            addTask()
        }
        
    }
    
    func dismissKeyboard() {
        
        if (isGroupEdit){
            let cell = cV.cellForItem(at: tmpIndexPath) as! GroupCell
            cell.textField.isUserInteractionEnabled = false
            cell.textField.resignFirstResponder()
            cvGroups[tmpIndexPath.row].name = cell.textField.text
            isGroupEdit = false
        }
        else{
            addTask()
        }
        
    }
    
    func diskey(){
        
        txtFld.resignFirstResponder()
        
    }
    
    
    func addTask(){
        
        diskey()
        
        if (txtFld.text != ""){
            
            let task = Task(name: txtFld.text!)
            
            cvGroups.insert(task, at: 0)
            txtFld.text = ""
            cV.reloadData()
        }
        
    }

    
}


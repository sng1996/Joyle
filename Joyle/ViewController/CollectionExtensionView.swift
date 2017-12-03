//
//  CollectionExtensionView.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 02.12.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //if (collectionView == cV){
        let itemSize = CGSize(width: collectionView.bounds.width - 20, height: 40)
        return itemSize
        /*}
         else{
         let itemSize = CGSize(width: collectionView.bounds.width - 20, height: 28)
         return itemSize
         }*/
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //if (collectionView == cV){
        return cvTasks.count
        /*}
         else{
         return checkPoints.count + 2
         }*/
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //if (collectionView == cV){
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TaskCell
        cell.label.text = cvTasks[indexPath.row].name
        cell.checkButton.frame.origin.x = CGFloat(10 + 10*cvTasks[indexPath.row].level)
        cell.checkButton.layer.borderColor = UIColor(red: 179/255.0, green: 179/255.0, blue: 179/255.0, alpha: 1.0).cgColor
        cell.checkButton.layer.borderWidth = 1.0
        cell.checkButton.layer.cornerRadius = 3
        cell.label.frame.origin.x = CGFloat(10 + 14 + 10 + 10*cvTasks[indexPath.row].level)
        cell.label.frame.size.width = CGFloat(268 - cell.label.frame.origin.x)
        cell.plusImageView.frame.origin.x = cell.checkButton.frame.origin.x + 3
        changeArrow(cell: cell, isOpen: cvTasks[indexPath.row].isOpen, isParent: !cvTasks[indexPath.row].subtasks.isEmpty)
        cell.setNeedsLayout()
        return cell
        //}
        /*else{
         if (indexPath.row == 0){
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moreNoteCell", for: indexPath) as! MoreNoteCell
         cell.textView.placeholder = "Добавить заметку"
         cell.frame.size.height = cell.textView.frame.size.height
         return cell
         }
         else if (indexPath.row == 1){
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moreAddPointCell", for: indexPath) as! MoreAddPointCell
         cell.backgroundColor = UIColor(red: 249/255.0, green: 249/255.0, blue: 249/255.0, alpha: 1.0)
         cell.layer.cornerRadius = 3
         return cell
         }
         else{
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moreCell", for: indexPath) as! MoreCell
         cell.label.text = checkPoints[indexPath.row-2]
         return cell
         }
         }*/
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        closeEmptyTask(from: sourceIndexPath.row)
        removeFromParent(from: sourceIndexPath.row)
        let temp = cvTasks.remove(at: sourceIndexPath.item)
        insertInParent(element: temp, at: destinationIndexPath.row)
        cvTasks.insert(temp, at: destinationIndexPath.row)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        /*if (cvTasks[indexPath.row].subtasks.count != 0 && cvTasks[indexPath.row].isOpen == false){
         openTask(indexPath: indexPath)
         }
         
         else if (cvTasks[indexPath.row].isOpen){
         closeTask(indexPath: indexPath)
         }*/
        openMoreView(indexPath: indexPath, collectionView: collectionView)
        
    }
    
    internal func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        let index = sender as! Int
        if index == 2{
            openCalendarView()
        }
        /*let flag = sender as! Int
         var tmpParent: Task!
         if (cvTasks[indexPath.row].level > 0){
         tmpParent = cvTasks[indexPath.row].parent
         }
         //////////////////////Копирование задачи
         if (flag == 1){
         /////////////////Закрытие подзадач
         if (cvTasks[indexPath.row].isOpen){
         closeTask(indexPath: indexPath)
         }
         /////////////////Удаление из массива подзадач
         if (cvTasks[indexPath.row].level > 0){
         let indexOfA = tmpParent.subtasks.index(of: cvTasks[indexPath.row])
         tmpParent.subtasks.remove(at: indexOfA!)
         }
         ////////////////Удаление из массива задач
         tmpTask = cvTasks.remove(at: indexPath.row)
         
         ////////////////Удаление с анимацией
         cV.deleteItems(at: [indexPath])
         isCopyTime = true
         
         ///////////////////////Закрытие задачи
         } else if (flag == 2){
         /////////////////Закрытие подзадач
         if (cvTasks[indexPath.row].isOpen){
         closeTask(indexPath: indexPath)
         }
         cvTasks[indexPath.row].isFinish = true
         if (cvTasks[indexPath.row].level > 0){
         let indexOfA = tmpParent.subtasks.index(of: cvTasks[indexPath.row])
         tmpParent.subtasks.remove(at: indexOfA!)
         }
         finishedTasks.append(cvTasks.remove(at: indexPath.row))
         cV.deleteItems(at: [indexPath])
         //////////////////////Удаление задачи
         } else if (flag == 3){
         if (cvTasks[indexPath.row].isOpen){
         closeTask(indexPath: indexPath)
         }
         if (cvTasks[indexPath.row].level > 0){
         let indexOfA = tmpParent.subtasks.index(of: cvTasks[indexPath.row])
         tmpParent.subtasks.remove(at: indexOfA!)
         }
         cvTasks.remove(at: indexPath.row)
         cV.deleteItems(at: [indexPath])
         /////////////////Редактирование задачи
         } else if (flag == 4){
         let cell = collectionView.cellForItem(at: indexPath) as! TaskCell
         let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
         let nextViewController = storyBoard.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
         nextViewController.task = cvTasks[indexPath.row]
         nextViewController.indexPath = indexPath
         nextViewController.delegate = self
         self.present(nextViewController, animated:true, completion:nil)
         UIView.animate(withDuration: 0.2, animations: {
         cell.setNeedsLayout()
         cell.layoutIfNeeded()
         })
         }*/
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        var edgeInsets = UIEdgeInsets()
        edgeInsets = UIEdgeInsetsMake(5,5,5,5)
        return edgeInsets;
        
    }
    
}


//
//  MenuViewController.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 20.11.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet var searchView: UIView!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var notificationButton: UIButton!
    @IBOutlet var notificationImageView: UIImageView!
    @IBOutlet var inboxCountView: UIView!
    @IBOutlet var inboxCountLabel: UILabel!
    @IBOutlet var todayCountView: UIView!
    @IBOutlet var todayCountLabel: UILabel!
    @IBOutlet var todayTimeView: UIView!
    @IBOutlet var todayTimeLabel: UILabel!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var tV: UITableView!
    @IBOutlet var secondSegmentedControlView: UIView!
    @IBOutlet var secondSegmentedControl: UISegmentedControl!
    @IBOutlet var rightButtonView: UIView!
    @IBOutlet var rightButton: UIButton!
    @IBOutlet var rightButtonPlus: UIImageView!
    @IBOutlet var rightButtonArrow: UIImageView!
    @IBOutlet var bannerView: UIView!
    
    var groupsArray: [String] = []
    var tagsArray: [String] = []
    var bannerIsOpen: Bool = false
    var currentContentHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        
        groupsArray = [
            "Маркетинг Joyle",
            "Мобильная разработка альбомного сервиса",
            "Баку",
            "Владивосток",
            "Kek",
            "Kek",
            "Kek",
            "Kek",
            "Kek",
            "Kek",
            "Kek",
            "Kek",
            "Kek",
            "Kek"
        ]
        
        tagsArray = [
            "Маркетинг",
            "Покупки",
            "Конская залупа",
            "Поросёнок"
        ]
        
        searchView.layer.cornerRadius = 4
        notificationButton.layer.cornerRadius = 4
        inboxCountView.layer.cornerRadius = 10
        todayCountView.layer.cornerRadius = 10
        todayTimeView.layer.cornerRadius = 10
        
        let attr = NSDictionary(object: UIFont(name: "MuseoSansCyrl-300", size: 14.0)!, forKey: NSFontAttributeName as NSCopying)
        segmentedControl.setTitleTextAttributes(attr as [NSObject : AnyObject] , for: .normal)
        secondSegmentedControl.setTitleTextAttributes(attr as [NSObject : AnyObject] , for: .normal)
        
        rightButtonView.layer.cornerRadius = 20
        rightButton.layer.cornerRadius = 20
        
    }
    
    @IBAction func openBanner(){
        
        if (bannerIsOpen){
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                self.rightButtonPlus.transform = self.rightButtonPlus.transform.rotated(by: CGFloat(CGFloat.pi/4))
            }, completion: { finished in
                self.rightButtonArrow.isHidden = false
            })
            bannerView.isHidden = true
            bannerIsOpen = false
        }
        else{
            rightButtonArrow.isHidden = true
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                self.rightButtonPlus.transform = self.rightButtonPlus.transform.rotated(by: CGFloat(CGFloat.pi/4))
            }, completion: { finished in
            })
            bannerView.isHidden = false
            bannerIsOpen = true
        }
        
    }
    
    @IBAction func indexChanged(sender: UISegmentedControl){
        if (secondSegmentedControl == sender){
            self.tV.contentOffset.y = 207.0
            segmentedControl.selectedSegmentIndex = secondSegmentedControl.selectedSegmentIndex
        }
        else{
            secondSegmentedControl.selectedSegmentIndex = segmentedControl.selectedSegmentIndex
        }
        tV.reloadData()
    }

}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (segmentedControl.selectedSegmentIndex == 0){
            return checkLabelFrame(string: groupsArray[indexPath.row]) + 20
        }
        else{
            return checkLabelFrame(string: tagsArray[indexPath.row]) + 20
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (segmentedControl.selectedSegmentIndex == 0){
            return groupsArray.count
        }
        else{
            return tagsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as! GroupCell
        
        if (segmentedControl.selectedSegmentIndex == 0){
            cell.icon.image = UIImage(named: "folder-icon")
            cell.label.text = groupsArray[indexPath.row]
            updateLabelFrame(label: cell.label)
            cell.selectionStyle = .none
        }
        else{
            cell.icon.image = UIImage(named: "tags")
            cell.label.text = tagsArray[indexPath.row]
            updateLabelFrame(label: cell.label)
            cell.selectionStyle = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (tV.contentOffset.y > 242.0){
            secondSegmentedControlView.isHidden = false
            let bottom = self.view.frame.size.height - 60.0 - (tV.contentSize.height - 242.0)
            if (bottom > 0){
                tV.contentInset.bottom = bottom
            }
            else{
                tV.contentInset.bottom = 0
            }
        }
        else{
            secondSegmentedControlView.isHidden = true
            let bottom = self.view.frame.size.height - 60.0 - (tV.contentSize.height - 242.0)
            if (bottom > 0){
                tV.contentInset.bottom = bottom
            }
            else{
                tV.contentInset.bottom = 0
            }
        }
    }
    
}

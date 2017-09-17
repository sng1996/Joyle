//
//  EditViewController.swift
//  Joyle
//
//  Created by Сергей Гаврилко on 16.09.17.
//  Copyright © 2017 Сергей Гаврилко. All rights reserved.
//

import UIKit

protocol isAbleToReceiveData {
    func pass(data: Task, path: IndexPath)  //data: string is an example parameter
}

class EditViewController: UIViewController{
    
    
    @IBOutlet var nameTxtFld: UITextField!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var desTxtView: UITextView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var ok: UIBarButtonItem!
    
    var delegate: isAbleToReceiveData?
    
    var task: Task!
    var indexPath: IndexPath!

    override func viewDidLoad() {
        super.viewDidLoad()

        nameTxtFld.text = task.name
        dateLbl.text = task.date
        dateLbl.isUserInteractionEnabled = true
        desTxtView.text = task.des
        datePicker.isHidden = true
        datePicker.backgroundColor = UIColor.white
        ok.title = ""
        
        var tap = UITapGestureRecognizer(target: self, action: #selector(changeDate(sender:)))
        dateLbl.addGestureRecognizer(tap)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func changeDate(sender: UILabel){
        
        datePicker.isHidden = false
        ok.title = "готово"
        
    }
    
    @IBAction func pressOk(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy hh:mm"
        task.date = formatter.string(from: datePicker.date)
        dateLbl.text = task.date
        datePicker.isHidden = true
        ok.title = ""
        
    }
    
    @IBAction func pressDone(){
        
        task.name = nameTxtFld.text
        task.des = desTxtView.text
        delegate?.pass(data: task, path: indexPath)
        dismiss(animated: true, completion: nil)

        
    }
    
    func dismissKeyboard(){
        
        nameTxtFld.resignFirstResponder()
        desTxtView.resignFirstResponder()
        
    }
    
    
    

}

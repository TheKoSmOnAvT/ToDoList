//
//  ViewController.swift
//  ToDoList
//
//  Created by Никита Попов on 03.07.2020.
//  Copyright © 2020 Никита Попов. All rights reserved.
//

import UIKit
import CoreData

//protocol addTaskViewControllerDelegate{
//    func addObject(_ addTaskViewController : AddTask, didAddObject : ToDoObject )
//}


class AddTask: UIViewController {

   // var delegate : addTaskViewControllerDelegate?
    
    @IBOutlet weak var tittle: UITextField!
    
    @IBOutlet weak var info: UITextView!
    
    @IBOutlet weak var date: UIDatePicker!
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addAction (_ sender : UIBarButtonItem){
        let tittle = self.tittle.text ?? ""
        let info = self.info.text ?? ""
     //   let newTask = ToDoObject(tittle : tittle,info: info,date: date.date)
      //  delegate?.addObject(self, didAddObject: newTask)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let task =  ToDoObject(context: context)
        task.info = info
        task.tittle = tittle
        task.date = date.date  //as NSDate?
        task.taskId = UUID().uuidString
    
        if let uid = task.taskId {
            print("id : \(uid)")
        }
        
        do {
            try context.save()
        } catch let err {
            print("error : \(err)")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        info.layer.borderColor = UIColor.lightGray.cgColor
        info.layer.borderWidth = 1.5
        info.layer.cornerRadius = 4
        
        tittle.layer.borderColor = UIColor.lightGray.cgColor
        tittle.layer.borderWidth = 1.5
        tittle.layer.cornerRadius = 4
        
        date.minimumDate = Date()
    }


}


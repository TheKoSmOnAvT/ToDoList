//
//  ViewController.swift
//  ToDoList
//
//  Created by Никита Попов on 03.07.2020.
//  Copyright © 2020 Никита Попов. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

//protocol addTaskViewControllerDelegate{
//    func addObject(_ addTaskViewController : AddTask, didAddObject : ToDoObject )
//}


class AddTask: UIViewController, UITextFieldDelegate , UITextViewDelegate{

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
            
            let notificationMessage = "\(tittle) reminder "
            let content = UNMutableNotificationContent()
            content.body = notificationMessage
            content.sound = UNNotificationSound.default
            let dateComponents = Calendar.current.dateComponents([.day, .month, .year, .hour, .minute], from: date.date)
            let triger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            if let indetifier = task.taskId {
                
                let request = UNNotificationRequest(identifier: indetifier, content: content, trigger: triger)
                let center = UNUserNotificationCenter.current()
                center.add(request, withCompletionHandler: nil)
                
            }
        } catch let err {
            print("error : \(err)")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
          self.info.delegate = self
         self.tittle.delegate = self
        info.layer.borderColor = UIColor.lightGray.cgColor
        info.layer.borderWidth = 1.5
        info.layer.cornerRadius = 4
        
        tittle.layer.borderColor = UIColor.lightGray.cgColor
        tittle.layer.borderWidth = 1.5
        tittle.layer.cornerRadius = 4
        
        date.minimumDate = Date()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      self.view.endEditing(true)
      return false
  }

}


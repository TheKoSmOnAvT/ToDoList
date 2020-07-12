//
//  InfoViewController.swift
//  ToDoList
//
//  Created by Никита Попов on 12.07.2020.
//  Copyright © 2020 Никита Попов. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class InfoViewController : UIViewController {
    
        let dateFormatter = DateFormatter()
    
        var objectId = ""
    
        func setObject(_ objectId: String) {
            do  {
                let tasks =  try getDataask(objectId)
                let task =  try tasks[0]
                self.tittle.text = task.tittle ?? ""
                
                if let date = task.date {
                    self.dateText.text = dateFormatter.string(from: date)
                }
                self.info.text = task.info ?? ""
            } catch let err {
                print("Error : \(err)")
            }
        }
    
    
    @IBOutlet weak var tittle: UITextField!
    @IBOutlet weak var info: UITextView!
    @IBOutlet weak var dateText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat  = "dd-MM-yyyy HH:mm"
        
        info.layer.borderColor = UIColor.lightGray.cgColor
        info.layer.borderWidth = 1.5
        info.layer.cornerRadius = 4
        
        tittle.layer.borderColor = UIColor.lightGray.cgColor
        tittle.layer.borderWidth = 1.5
        tittle.layer.cornerRadius = 4
        
        dateText.layer.borderColor = UIColor.lightGray.cgColor
        dateText.layer.borderWidth = 1.5
        dateText.layer.cornerRadius = 4
        setObject(objectId)
    }
    
    
    func getDataask(_ taskId : String) throws -> [ToDoObject] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<ToDoObject>(entityName: "ToDoObject")
        request.predicate = NSPredicate(format: "taskId == %@", taskId)
        let task = try context.fetch(request)
        return task
    }

}

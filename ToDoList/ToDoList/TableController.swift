//
//  UITableTableViewController.swift
//  ToDoList
//
//  Created by Никита Попов on 05.07.2020.
//  Copyright © 2020 Никита Попов. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications


class TableController: UITableViewController  {/*,addTaskViewControllerDelegate*/

    var tasks = [ToDoObject]()
    
    var selectedCell : String = ""
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateFormat  = "dd-MM-yyyy HH:mm"
        //let test = ToDoObject(tittle: "title", info: "info", date: Date())
        //tasks.append(test)

    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        

        return tasks.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taslCellIdentifier", for: indexPath)
        
        let task = tasks[indexPath.row]
        
        cell.textLabel?.text = task.tittle ?? " "
        if let date = task.date {
            cell.detailTextLabel?.text = dateFormatter.string(from: date)
        } else {
            cell.detailTextLabel?.text = " "
        }
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = ToDoObject.fetchRequest() as NSFetchRequest<ToDoObject>
        let sortByDateTime = NSSortDescriptor(key: "date", ascending: true)
        let sortByTittle = NSSortDescriptor(key: "tittle", ascending: true)
        
        fetchRequest.sortDescriptors = [sortByDateTime, sortByTittle]
        
        do{
            tasks = try context.fetch(fetchRequest)
        } catch let err {
            print("error \(err)")
        }

        tableView.reloadData()
    }


    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.

        return true
    }

    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     
        if tasks.count > indexPath.row{
            let task =  tasks[indexPath.row]
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            context.delete(task)
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            if let taskId = task.taskId {
                    let centet = UNUserNotificationCenter.current()
                    centet.removePendingNotificationRequests(withIdentifiers: [taskId])
                }
            
            do {
                try context.save()
            } catch let err {
                print("error : \(err)")
            }
        }
    }
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
         selectedCell = tasks[indexPath.row].taskId!
        return indexPath
      
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

  
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showData" else { return }
        guard let destination = segue.destination as? InfoViewController else { return }
        destination.objectId = selectedCell
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let navigationController = segue.destination as! UINavigationController
//        let addTaskViewController = navigationController.topViewController as! AddTask
//        addTaskViewController.delegate = self
//    }
    
//  // MARK: - delegate
//    func addObject(_ addTaskViewController : AddTask, didAddObject : ToDoObject ){
//
//        tasks.append(didAddObject)
//        tableView.reloadData()
//    }
}

//
//  toDoObject.swift
//  ToDoList
//
//  Created by Никита Попов on 04.07.2020.
//  Copyright © 2020 Никита Попов. All rights reserved.
//

import Foundation

class toDoObject{
    let tittle : String
    let info : String
    let date : Date
    
    init(tittle : String, info : String, date : Date ){
        self.tittle =  tittle
        self.info = info
        self.date = date
    }
}

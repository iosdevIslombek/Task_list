//
//  Structs.swift
//  Exam_TableView
//
//  Created by Islomjon on 25/05/22.
//

import Foundation
import UIKit

enum Priority:String, Codable{
    case high
    case medium
    case low
    case none
}

enum CategoryType:Codable{
    case new, finish, archive
}

struct ToDoListDM:Codable{
    var title:String
    var desc:String
    var priority:Priority?
}

struct CategoryDM:Codable{
    
    var title:String
    var type:CategoryType
    var tasks:[ToDoListDM]
    
    func taskIsEmpty() -> Bool{
        return tasks.isEmpty
    }
}

//
//  TodolistTVC.swift
//  Exam_TableView
//
//  Created by Islomjon on 25/05/22.
//

import UIKit

class TodolistTVC: UITableViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var priorityView: UIView!
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    
    
    func updateCell(task: ToDoListDM, sectionType:CategoryType){
        titleLbl.text = task.title
        descriptionLbl.text = task.desc
        
        switch sectionType {
            case .new:
                mainView.backgroundColor = .systemGray6
            case .finish:
                mainView.backgroundColor = .systemGray5
            case .archive:
                mainView.backgroundColor = .systemGray4
        }
        
        if let pri = task.priority{
            switch pri{
                case .high:
                    priorityView.backgroundColor = .systemRed
                case .medium:
                    priorityView.backgroundColor = .systemYellow
                case .low:
                    priorityView.backgroundColor = .systemGreen
                case .none:
                    priorityView.backgroundColor = .systemGray
            }
        }else{
            priorityView.backgroundColor = .systemGray6
        }
        
    }
    
}

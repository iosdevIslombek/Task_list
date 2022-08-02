//
//  NewTaskVC.swift
//  Exam_TableView
//
//  Created by Islomjon on 25/05/22.
//

import UIKit

protocol NewTaskVCDelegate {
    func addTask(task:ToDoListDM)
}

class NewTaskVC: UIViewController {

    @IBOutlet weak var newTaskView: UIView!{
        didSet{
            newTaskView.layer.borderWidth = 1
            newTaskView.layer.borderColor = UIColor.green.cgColor
            newTaskView.clipsToBounds = true
        }
    }
    @IBOutlet weak var taskTitleTf: UITextField!{
        didSet{
            taskTitleTf.layer.cornerRadius = 12
        }
    }
    @IBOutlet weak var taskDeskTv: UITextView!{
        didSet{
            taskDeskTv.layer.cornerRadius = 8
            taskDeskTv.layer.borderWidth = 1
            taskDeskTv.layer.borderColor = UIColor.systemGray3.cgColor
        }
    }
    @IBOutlet weak var addTaskBtn: UIButton!
    @IBOutlet weak var choosePreorityBtn: UIButton!
    
    var delegate:NewTaskVCDelegate?
    var selectpriority:Priority?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setToolbar()
    }
    
    func setToolbar(){
//        taskTitleTf.resignFirstResponder()
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        doneBtn.tintColor = .black
        let spaceBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolbar.items = [spaceBtn, doneBtn]
        
        taskTitleTf.inputAccessoryView = toolbar
        taskDeskTv.inputAccessoryView = toolbar
        
    }
    
    @objc func doneTapped(){
        taskTitleTf.resignFirstResponder()
        taskDeskTv.resignFirstResponder()
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func choosePreorityTapped(_ sender: Any) {
        let priorityVC = PreorityVC(nibName: "PreorityVC", bundle: nil)
        priorityVC.delegate = self
        priorityVC.modalPresentationStyle = .overFullScreen
        present(priorityVC, animated: true)
    }
    
    @IBAction func addTaskTapped(_ sender: Any) {
        if (taskTitleTf.text ?? "").isEmpty{
            showAlert()
        }else{
            
            delegate?.addTask(task: ToDoListDM(title: taskTitleTf.text ?? "",
                                               desc: taskDeskTv.text,
                                               priority: selectpriority))
            dismiss(animated: true)
        }
        
    }
}

//MARK: - Alert Sheet -
extension NewTaskVC{
    func showAlert(){
        let alert = UIAlertController(title: "Task title can not be empty",
                                     message: "Please write the task title in order to create  new task.",
                                     preferredStyle: .alert)
        
        let okBtn = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okBtn)
        present(alert, animated: true)
    }
}

//MARK: - PriorityVCDelegate
extension NewTaskVC:PreorityVCDelegate{
    func getPriority(pri: Priority) {
        switch pri {
            case .high:
                self.choosePreorityBtn.backgroundColor = .systemRed
            case .medium:
                self.choosePreorityBtn.backgroundColor = .systemYellow
            case .low:
                self.choosePreorityBtn.backgroundColor = .systemGreen
            case .none:
                self.choosePreorityBtn.backgroundColor = .lightGray
        }
        self.choosePreorityBtn.setTitle(pri.rawValue.capitalized, for: .normal)
        self.selectpriority = pri
    }
}

//
//  MainVC.swift
//  Exam_TableView
//
//  Created by Islomjon on 25/05/22.
//

import UIKit
import SafariServices

class MainVC: UIViewController {
    
    
    @IBOutlet weak var imageBtn: UIButton!
    
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet{
            searchBar.delegate = self
        }
    }
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.register((UINib(nibName: "TodolistTVC", bundle: nil)), forCellReuseIdentifier: "TodolistTVC")
        }
    }
    
    var sectionData:[CategoryDM] = [
        CategoryDM(title: "New tasks", type: .new, tasks: []),
        CategoryDM(title: "Finished tasks", type: .finish, tasks: []),
        CategoryDM(title: "Archive tasks", type: .archive, tasks: [])
    ]
    
    var stringLink:String = ""
    
    var allTasks:[CategoryDM] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sectionData[0].tasks = getTasks(key: "NEWTASK")
        sectionData[1].tasks = getTasks(key: "FINISHTASK")
        sectionData[2].tasks = getTasks(key: "ARCHIVETASK")
        imageBtn.setImage(loadImage(), for: .normal)
        
    }
    
    func loadImage()->UIImage{
        guard let data = UserDefaults.standard.data(forKey: "KEY") else{ return UIImage(systemName: "person.fill")!}
        let decoded = try! PropertyListDecoder().decode(Data.self, from:data)
        let image = UIImage(data: decoded)
        return image ?? UIImage(systemName: "person.fill")!
    }
    
    
    @IBAction func profileImgTapped(_ sender: Any) {
        let profileVC = ProfileVC(nibName: "ProfileVC", bundle: nil)
//        profileVC.modalPresentationStyle = .fullScreen
        present(profileVC, animated: true)
    }
    
    @IBAction func plusTapped(_ sender: Any) {
        let newTaskVC = NewTaskVC(nibName: "NewTaskVC", bundle: nil)
        newTaskVC.modalPresentationStyle = .overFullScreen
        newTaskVC.delegate = self
        present(newTaskVC, animated: true)
    }
}

//MARK: - UITableViewDelegate, UITableViewDataSource -

extension MainVC:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showAlert(type: sectionData[indexPath.section].type, index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let v = UIView()
        
        let x = self.tableView.frame.width/2 - 90
        let y = 10
        let lbl = UILabel(frame: CGRect(x: Int(x), y: y, width: 180, height: 40))
        lbl.text = sectionData[section].title
        lbl.textColor = .systemGreen
        lbl.font = .systemFont(ofSize: 19, weight: .semibold)
        lbl.backgroundColor = .systemGray6
        lbl.clipsToBounds = true
        lbl.layer.cornerRadius = 20
        lbl.textAlignment = .center
        
        v.addSubview(lbl)
        
        if sectionData[section].taskIsEmpty(){
            return UIView()
        }else{
            return v
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if sectionData[section].taskIsEmpty(){
            return 0
        }
        return 60
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sectionData[section].tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodolistTVC", for: indexPath) as? TodolistTVC else {
            return UITableViewCell()
        }
        cell.updateCell(task: sectionData[indexPath.section].tasks[indexPath.row], sectionType: sectionData[indexPath.section].type)
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [self] _, _, _ in
            if sectionData[indexPath.section].type == .new{
                sectionData[0].tasks.remove(at: indexPath.row)
                saveTask(todo: sectionData[0].tasks, key: "NEWTASK")
//                saveTask(todo:sectionData[0].tasks)
            }else if sectionData[indexPath.section].type == .finish{
                sectionData[1].tasks.remove(at: indexPath.row)
                saveTask(todo:sectionData[1].tasks, key: "FINISHTASK")
            }else if sectionData[indexPath.section].type == .archive{
                sectionData[2].tasks.remove(at: indexPath.row)
                saveTask(todo:sectionData[2].tasks, key: "ARCHIVETASK")
            }
            tableView.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let finish = UIContextualAction(style: .normal, title: "Finish 🎉") { [self] _, _, _ in
            if sectionData[indexPath.section].type == .new{
                let task = sectionData[0].tasks.remove(at: indexPath.row)
                sectionData[1].tasks.append(task)
                saveTask(todo:sectionData[0].tasks, key: "NEWTASK")
                saveTask(todo:sectionData[1].tasks, key: "FINISHTASK")
            }
            tableView.reloadData()
        }
        finish.backgroundColor = .systemGreen
        
        
        
        let archive = UIContextualAction(style: .normal, title: "Archive") { [self] _, _, _ in
            if sectionData[indexPath.section].type == .new{
                let task = sectionData[0].tasks.remove(at: indexPath.row)
                sectionData[2].tasks.append(task)
                saveTask(todo:sectionData[0].tasks, key: "NEWTASK")
                saveTask(todo:sectionData[2].tasks, key: "ARCHIVETASK")
            }else if sectionData[indexPath.section].type == .finish{
                let task = sectionData[1].tasks.remove(at: indexPath.row)
                sectionData[2].tasks.append(task)
                saveTask(todo:sectionData[1].tasks, key: "FINISHTASK")
                saveTask(todo:sectionData[2].tasks, key: "ARCHIVETASK")
            }
            tableView.reloadData()
        }
        archive.backgroundColor = .systemOrange
        archive.image = UIImage(systemName: "tray.and.arrow.down.fill")
        
        let unfinish = UIContextualAction(style: .normal, title: "Unfinish ⬆️") { [self] _, _, _ in
            let task = sectionData[1].tasks.remove(at: indexPath.row)
            sectionData[0].tasks.append(task)
            saveTask(todo:sectionData[0].tasks, key: "NEWTASK")
            saveTask(todo:sectionData[1].tasks, key: "FINISHTASK")
            tableView.reloadData()
        }
        unfinish.backgroundColor = .systemBlue
        
        let unarchive = UIContextualAction(style: .normal, title: "Unarchive") { [self] _, _, _ in
            let task = sectionData[2].tasks.remove(at: indexPath.row)
            sectionData[0].tasks.append(task)
            saveTask(todo:sectionData[0].tasks, key: "NEWTASK")
            saveTask(todo:sectionData[2].tasks, key: "ARCHIVETASK")
            tableView.reloadData()
        }
        unarchive.backgroundColor = .systemOrange
        unarchive.image = UIImage(systemName: "tray.and.arrow.up.fill")
        
        if sectionData[indexPath.section].type == .new{
            return UISwipeActionsConfiguration(actions: [finish, archive])
        }else if sectionData[indexPath.section].type == .finish{
            return UISwipeActionsConfiguration(actions: [unfinish, archive])
        }else{
            return UISwipeActionsConfiguration(actions: [unarchive])
        }
        
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            
            let appleLink = UIAction(title: "Apple") { _ in
                print("Apple")
                self.stringLink = "https://www.apple.com"
                self.openSafari()
            }
            
            let samsungLink = UIAction(title: "Samsung") { _ in
                print("Samsung")
                self.stringLink = "https://www.samsung.com"
                self.openSafari()
            }
            
            let redmiLink = UIAction(title: "Microsoft") { _ in
                self.stringLink = "https://www.microsoft.com"
                self.openSafari()
            }
            
            let huaweiLink = UIAction(title: "Tesla") { _ in
                self.stringLink = "https://www.tesla.com"
                self.openSafari()
            }
            
            let link = UIMenu(title: "Open Safari", image: UIImage(systemName: "safari.fill"), children: [appleLink, samsungLink, huaweiLink, redmiLink])
            
            let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) {[self] _ in
                
                let title:String = sectionData[indexPath.section].tasks[indexPath.row].title
                let priority:String = sectionData[indexPath.section].tasks[indexPath.row].priority?.rawValue ?? "none"
                let shareVC = UIActivityViewController(activityItems: [title, priority], applicationActivities: [])
                
                present(shareVC, animated: true)
        
            }
            
            let contextMenu = UIMenu(title: "", image: nil, options: .displayInline, children: [link, share])
            
            return contextMenu
            
        }
    }
}

//MARK: - Open safari function -
extension MainVC{
    func openSafari(){
        if let urlLink = URL(string: stringLink){
            let safariVC = SFSafariViewController(url: urlLink)
            present(safariVC, animated: true)
        }else{
            errorAlert(title: "Error", desc: "Bunday manzil mavjud emas!")
        }
    }
}

//MARK: - NewTaskVCDelegate -
extension MainVC:NewTaskVCDelegate{
    
    func addTask(task: ToDoListDM) {

        self.sectionData[0].tasks.append(task)
        self.saveTask(todo: sectionData[0].tasks, key: "NEWTASK")
        self.tableView.reloadSections(IndexSet(integer: 0), with: .none)
        
    }
}

//MARK: - Alert Sheet
extension MainVC{
    func showAlert(type:CategoryType, index:Int){
        let alertVC = UIAlertController(title: "Choose what to do", message: nil, preferredStyle: .actionSheet)
        
        let finish = UIAlertAction(title: "Finish🎉", style: .default) { [self] _ in
            let task = sectionData[0].tasks.remove(at: index)
            sectionData[1].tasks.append(task)
            saveTask(todo:sectionData[0].tasks, key: "NEWTASK")
            saveTask(todo: sectionData[1].tasks, key: "FINISHTASK")
            tableView.reloadData()
        }
        
        let archive = UIAlertAction(title: "Archive", style: .default) { [self] _ in
            if type == .new{
                let task = sectionData[0].tasks.remove(at: index)
                sectionData[2].tasks.append(task)
                saveTask(todo:sectionData[0].tasks, key: "NEWTASK")
                saveTask(todo: sectionData[2].tasks, key: "ARCHIVETASK")
            }else if type == .finish{
                let task = sectionData[1].tasks.remove(at: index)
                sectionData[2].tasks.append(task)
                saveTask(todo:sectionData[0].tasks, key: "NEWTASK")
                saveTask(todo: sectionData[2].tasks, key: "ARCHIVETASK")
            }
            self.tableView.reloadData()
        }
        
        let delete = UIAlertAction(title: "Delete", style: .destructive) { [self] _ in
            if type == .new{
                sectionData[0].tasks.remove(at: index)
                saveTask(todo:sectionData[0].tasks, key: "NEWTASK")
            }else if type == .finish{
                sectionData[1].tasks.remove(at: index)
                saveTask(todo:sectionData[1].tasks, key: "FINISHTASK")
            }else if type == .archive{
                sectionData[2].tasks.remove(at: index)
                saveTask(todo:sectionData[2].tasks, key: "ARCHIVETASK")
            }
            self.tableView.reloadData()
        }
        
        let unarchive = UIAlertAction(title: "Unarchive", style: .default) { [self] _ in
            let task = sectionData[2].tasks.remove(at: index)
            sectionData[0].tasks.append(task)
            saveTask(todo:sectionData[2].tasks, key: "ARCHIVETASK")
            saveTask(todo:sectionData[0].tasks, key: "NEWTASK")
            tableView.reloadData()
        }
        
        let unfinish = UIAlertAction(title: "Unfinish ⬆️", style: .default) { [self] _ in
            let task = sectionData[1].tasks.remove(at: index)
            sectionData[0].tasks.append(task)
            saveTask(todo:sectionData[0].tasks, key: "NEWTASK")
            saveTask(todo:sectionData[1].tasks, key: "FINISHTASK")
            tableView.reloadData()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        if type == .new{
            
            alertVC.addAction(finish)
            alertVC.addAction(archive)
            
        }else if type == .finish{
            
            alertVC.addAction(unfinish)
            alertVC.addAction(archive)
            
        }else if type == .archive{
            
            alertVC.addAction(unarchive)
            
        }
        
        alertVC.addAction(delete)
        alertVC.addAction(cancel)
        present(alertVC, animated: true)
    }
    
    func errorAlert(title:String, desc:String){
        let error = UIAlertController(title: title, message: desc, preferredStyle: .actionSheet)
        let okBtn = UIAlertAction(title: "OK", style: .default)
        error.addAction(okBtn)
        present(error, animated: true)
    }
}

//MARK: - USERDEFAULT -
extension MainVC{
    
    func searchTask(category:CategoryDM, searchTask:ToDoListDM)->Bool{
        var isHave:Bool = true
        for task in category.tasks{
            if task.title == searchTask.title{
                isHave = false
                return false
            }else{
                isHave = true
            }
        }
        return isHave
    }
    
    func saveTask(todo:[ToDoListDM], key:String){
        let encoder = JSONEncoder()
        if let encodeTasks = try? encoder.encode(todo){
            let userdefault = UserDefaults.standard
            userdefault.set(encodeTasks, forKey: key)
        }
    }
    
    func getTasks(key:String)->[ToDoListDM]{
        let userdefault = UserDefaults.standard
        if let myTasks = userdefault.object(forKey: key) as? Data{
            let decoder = JSONDecoder()
            if let decodeTasks = try? decoder.decode([ToDoListDM].self, from: myTasks){
                return decodeTasks
            }
        }
        return []
    }
}


//MARK: - UISearchBarDelegate -
extension MainVC:UISearchBarDelegate{
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        sectionData = allTasks
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        searchBar.text = nil
        tableView.reloadData()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        allTasks = sectionData
        searchBar.showsCancelButton = true
        sectionData = [
            CategoryDM(title: "New tasks", type: .new, tasks: []),
            CategoryDM(title: "Finished tasks", type: .finish, tasks: []),
            CategoryDM(title: "Archive tasks", type: .archive, tasks: [])
        ]
        tableView.reloadData()
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        for category in allTasks{
            for task in category.tasks{
                if task.title.lowercased().contains(searchText.lowercased()){
                    if category.type == .new{
                        if searchTask(category: sectionData[0], searchTask: task){
                            sectionData[0].tasks.append(task)
                        }
                    }else if category.type == .finish{
                        if searchTask(category: sectionData[1], searchTask: task){
                            sectionData[1].tasks.append(task)
                        }
                    }else if category.type == .archive{
                        if searchTask(category: sectionData[2], searchTask: task){
                            sectionData[2].tasks.append(task)
                        }
                    }
                }
            }
        }
        tableView.reloadData()
    }
}

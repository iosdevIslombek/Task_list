//
//  LoginVC.swift
//  Exam_TableView
//
//  Created by Islomjon on 30/05/22.
//

import UIKit

class LoginVC: UIViewController {
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.layer.borderWidth = 1
            containerView.layer.borderColor = UIColor.gray.cgColor
        }
    }
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var gendaerTf: UITextField!
    @IBOutlet weak var birthdayTf: UITextField!
    @IBOutlet weak var nameTf: UITextField!
    
    let datePicker = UIDatePicker()
    let picker = UIPickerView()
    var genderArr:[String] = ["Male", "Famale"]
    
    let w = UIScreen.main.bounds.width
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDatePicker()
        setGenderPicker()
    }
    
    
    @IBAction func editTapped(_ sender: Any) {
        let imageVC = UIImagePickerController()
        imageVC.delegate = self
        imageVC.allowsEditing = true
//        imageVC.sourceType = .camera
        present(imageVC, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        containerView.layer.cornerRadius = w / 5
        imgView.layer.cornerRadius = (containerView.bounds.width-20) / 2
    }
    
    
    
    //MARK: - SET DATE PICKER -
    
    func setDatePicker(){
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = .current
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(getDate), for: .valueChanged)
        birthdayTf.inputView = datePicker
        
        //MARK: - SET TOOLBAR -
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        
        let spaceBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolbar.items = [spaceBtn, doneBtn]
        birthdayTf.inputAccessoryView = toolbar
    }
    
    @objc func getDate(){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        
        let myDay = formatter.string(from: datePicker.date)
        birthdayTf.text = myDay
    }
    
    @objc func doneTapped(){
        birthdayTf.resignFirstResponder()
    }
    
    
    
    //MARK: - SET GENDER PICKER -
    
    func setGenderPicker(){
        picker.delegate = self
        picker.dataSource = self
        gendaerTf.inputView = picker
        
        
        //MARK: - SET TOOLBAR -
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(genderDoneTapped))
        
        let spaceBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        toolbar.items = [spaceBtn, doneBtn]
        gendaerTf.inputAccessoryView = toolbar
        
    }
    
    @objc func genderDoneTapped(){
        gendaerTf.resignFirstResponder()
    }
    

    @IBAction func saveTapped(_ sender: Any) {
        
        if nameTf.text!.isEmpty || gendaerTf.text!.isEmpty{
            showAlert(title: "Error", desc: "Name and gender is not empty!")
        }else{
            UserDefaults.standard.set(nameTf.text, forKey: "USERNAME")
            UserDefaults.standard.set(gendaerTf.text, forKey: "GENDER")
            UserDefaults.standard.set(birthdayTf.text, forKey: "BIRTHDAY")
            UserDefaults.standard.set(true, forKey: "isUserLogged")
            
            let vc = MainVC(nibName: "MainVC", bundle: nil)
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
    }
}

//MARK: - UIImagePickerController, UIImagePickerControllerDelegate -
extension LoginVC:UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        showAlert(title: "Error", desc: "\(picker)")
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage]
        
        if let profileImg = image as? UIImage {
            
            self.imgView.image = profileImg
            
            guard let data = profileImg.jpegData(compressionQuality: 0.5) else { return }
            let encoded = try! PropertyListEncoder().encode(data)
            UserDefaults.standard.set(encoded, forKey: "KEY")
            
        }
        self.dismiss(animated: true)
    }
    
}



//MARK: - Alert -
extension LoginVC{
    
    func showAlert(title:String, desc:String){
        let alertVC = UIAlertController(title: title, message: desc, preferredStyle: .actionSheet)
        let okBtn = UIAlertAction(title: "OK", style: .default)
        alertVC.addAction(okBtn)
        present(alertVC, animated: true)
    }
    
}


//MARK: - UIPickerViewDelegate, UIPickerViewDataSource -

extension LoginVC:UIPickerViewDelegate, UIPickerViewDataSource{
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        gendaerTf.text = genderArr[row]
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderArr[row]
    }
    
    
}

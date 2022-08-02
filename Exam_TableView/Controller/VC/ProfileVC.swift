//
//  ProfileVC.swift
//  Exam_TableView
//
//  Created by Islomjon on 03/06/22.
//

import UIKit
import MessageUI

class ProfileVC: UIViewController {
    
    let w = UIScreen.main.bounds.width

    @IBOutlet weak var imgView: UIImageView!{
        didSet{
            imgView.layer.borderWidth = 1
            imgView.layer.borderColor = UIColor.gray.cgColor
            imgView.layer.cornerRadius = w / 5
        }
    }
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var genderLbl: UILabel!
    @IBOutlet weak var birthdayLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLbl.text = "Name: \(UserDefaults.standard.string(forKey: "USERNAME") ?? "")"
        genderLbl.text = "Gender: \(UserDefaults.standard.string(forKey: "GENDER") ?? "")"
        birthdayLbl.text = "Birthday: \(UserDefaults.standard.string(forKey: "BIRTHDAY") ?? "")"
        imgView.image = loadImage()
    }
    
    
    @IBAction func sendMailTapped(_ sender: Any) {
        
        if MFMailComposeViewController.canSendMail(){
            let mailVC = MFMailComposeViewController()
            mailVC.mailComposeDelegate = self
            mailVC.setToRecipients(["razzoqov_96@mail.ru"])
            mailVC.setSubject("New Message")
            mailVC.setMessageBody("Body", isHTML: true)
            present(mailVC, animated: true)
        }else{
            showAlert()
        }
    }
    
    
    func loadImage()->UIImage{
        guard let data = UserDefaults.standard.data(forKey: "KEY") else{ return UIImage(systemName: "person.fill")!}
        let decoded = try! PropertyListDecoder().decode(Data.self, from:data)
        let image = UIImage(data: decoded)
        return image ?? UIImage(systemName: "person.fill")!
    }
    
}

//MARK: - Alert -
extension ProfileVC{
    func showAlert(){
        let alertVC = UIAlertController(title: "Error", message: "This email no sent message", preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .default)
        alertVC.addAction(okBtn)
        present(alertVC, animated: true)
    }
}

//MARK: - MFMailComposeViewControllerDelegate -

extension ProfileVC:MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true)
    }
}

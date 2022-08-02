//
//  PreorityVC.swift
//  Exam_TableView
//
//  Created by Islomjon on 25/05/22.
//

import UIKit

protocol PreorityVCDelegate {
    func getPriority(pri:Priority)
}

class PreorityVC: UIViewController {
    @IBOutlet weak var buttonsView: UIView!{
        didSet{
            buttonsView.layer.cornerRadius = 20
        }
    }
    
    var priorities:[Priority] = [.high, .medium, .low, .none]
    var delegate:PreorityVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func dismisBtnTapped(_ sender:UIButton){
        dismiss(animated: true)
    }
    
    @IBAction func preorityBtns(_ sender: UIButton) {
        delegate?.getPriority(pri: priorities[sender.tag])
        dismiss(animated: true)
    }
}

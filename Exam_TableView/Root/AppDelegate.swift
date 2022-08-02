//
//  AppDelegate.swift
//  Exam_TableView
//
//  Created by Islomjon on 23/05/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        if UserDefaults.standard.bool(forKey: "isUserLogged"){
            let vc = MainVC(nibName: "MainVC", bundle: nil)
            window?.rootViewController = vc
        }else{
            let vc = LoginVC(nibName: "LoginVC", bundle: nil)
            window?.rootViewController = vc
        }
        window?.makeKeyAndVisible()
        return true
    }
}


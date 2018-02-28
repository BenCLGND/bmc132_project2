//
//  ViewController.swift
//  bmc132_project2
//
//  Created by Clark,Benjamin on 2/21/18.
//  Copyright © 2018 Clark,Benjamin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {


    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var gamePlatformField: UITextField!
    @IBOutlet weak var gameGenreField: UITextField!
    @IBOutlet weak var gameDeveloperField: UITextField!
    
    struct appInfo {
        
        var userName = ""
        var age = 0
        var favePlatform = ""
        var faveGameGenre = ""
        var faveGameDeveloper = ""
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.nameField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.nameField.resignFirstResponder()
        
        return true
    }

}


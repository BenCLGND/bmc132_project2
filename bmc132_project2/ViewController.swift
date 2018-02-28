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
        self.ageField.delegate = self
        self.gamePlatformField.delegate = self
        self.gameGenreField.delegate = self
        self.gameDeveloperField.delegate = self
        
        // shifts the view up for space for the keyboard
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow, object: nil, queue: nil) {
            notification in
            
            // find the size of the keyboard
            guard let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                print("ERROR: Unable to get keyboard size")
                return
            }
            
            // move the whole thing up
            self.view.frame.origin.y = -keyboardSize.height
        }
        
        // shifts the view up for space for the keyboard
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: nil) {
            notification in
            
            // move back to original position
            self.view.frame.origin.y = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.nameField.resignFirstResponder()
        self.ageField.resignFirstResponder()
        self.gamePlatformField.resignFirstResponder()
        self.gameGenreField.resignFirstResponder()
        self.gameDeveloperField.resignFirstResponder()
        
        return true
    }
    
    
    
}


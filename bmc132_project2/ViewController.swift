//
//  ViewController.swift
//  bmc132_project2
//
//  Created by Clark,Benjamin on 2/21/18.
//  Copyright © 2018 Clark,Benjamin. All rights reserved.
//

import UIKit

struct appInfo : Codable {
    
    var Name: String?
    var Age: String?
    var FavoriteGamingPlatform: String?
    var FavoriteGameGenre: String?
    var FavoriteGameDeveloper: String?
    
}

class ViewController: UIViewController, UITextFieldDelegate {

    
    var userInput = appInfo()
    var activeField: UITextField!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var gamePlatformField: UITextField!
    @IBOutlet weak var gameGenreField: UITextField!
    @IBOutlet weak var gameDeveloperField: UITextField!
    
    lazy var plistURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("userInfo").appendingPathExtension("plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameField.delegate = self
        self.ageField.delegate = self
        self.gamePlatformField.delegate = self
        self.gameGenreField.delegate = self
        self.gameDeveloperField.delegate = self
        
        
        defer {
            self.nameField.text = self.userInput.Name
            self.ageField.text = self.userInput.Age
            self.gamePlatformField.text = self.userInput.FavoriteGamingPlatform
            self.gameGenreField.text = self.userInput.FavoriteGameGenre
            self.gameDeveloperField.text = self.userInput.FavoriteGameDeveloper
        }
        
        //MARK: Begin Reading and decoding plist
        guard let userInputURL = Bundle.main.url(forResource: "userInfo", withExtension: "plist") else {
            print("Error: Path cannot be formed")
            return
        }

        guard let userInputData = try? Data(contentsOf: userInputURL) else {
            print("Error: Data not found")
            return
        }

        guard let userInput = try? PropertyListDecoder().decode(appInfo.self, from: userInputData) else {
            print("Error: Data couldn't be retrieved from plist")
            return
        }
        
        self.userInput = userInput
        
        //MARK: Begin reading/decoding of user plist
        guard let localData = try? Data(contentsOf: userInputURL) else {
            print("Error: Data not found")
            return
        }
        
        guard let localUserInputData = try? PropertyListDecoder().decode(appInfo.self, from: localData) else {
            print("Data couldn't be retrieved from plist")
            return
        }
        
        self.userInput = localUserInputData
        
        //MARK: Moving Keyboard for text fields
        
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow, object: nil, queue: nil) {
            notification in
            
            guard let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                print("ERROR: Unable to get keyboard size")
                return
            }
            
            if self.activeField == self.nameField {
                return
            }
            else if self.activeField == self.ageField {
                return
            }
            else if self.activeField == self.gamePlatformField{
                self.view.frame.origin.y = -keyboardSize.height + 200
            }
            else if self.activeField == self.gameGenreField{
                self.view.frame.origin.y = -keyboardSize.height + 100
            }
            else {
                self.view.frame.origin.y = -keyboardSize.height + 50
            }

        }
        
        NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: nil) {
            notification in
            
            self.view.frame.origin.y = 0
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        DispatchQueue.main.async {
            if let currentName = self.nameField.text, let currentAge = self.ageField.text, let currentFavePlatform = self.gamePlatformField.text, let currentFaveGenre = self.gameGenreField.text, let currentGameDeveloper = self.gameDeveloperField.text {
                
                self.userInput.Name = currentName
                self.userInput.Age = currentAge
                self.userInput.FavoriteGamingPlatform = currentFavePlatform
                self.userInput.FavoriteGameGenre = currentFaveGenre
                self.userInput.FavoriteGameDeveloper = currentGameDeveloper
                
                let encoder = PropertyListEncoder()
                encoder.outputFormat = .xml
                do {
                    try encoder.encode(self.userInput).write(to: self.plistURL)
                } catch {
                    print(error)
                }
                
                //print("User Data File: \(self.plistURL)")
            }
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
}


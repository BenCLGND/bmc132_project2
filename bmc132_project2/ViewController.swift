//
//  ViewController.swift
//  bmc132_project2
//
//  Created by Clark,Benjamin on 2/21/18.
//  Copyright © 2018 Clark,Benjamin. All rights reserved.
//

import UIKit

//Struct to hold data for plist writing/reading
struct appInfo : Codable {
    
    var Name: String?
    var Age: String?
    var FavoriteGamingPlatform: String?
    var FavoriteGameGenre: String?
    var FavoriteGameDeveloper: String?
    
}

class ViewController: UIViewController, UITextFieldDelegate {

    //MARK: Variables to pass to functions
    var userInput = appInfo()
    var activeField: UITextField!
    
    //Var to write plist in bundle
    lazy var plistURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("userInfo").appendingPathExtension("plist")
    
    //MARK: Text Field References
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var ageField: UITextField!
    @IBOutlet weak var gamePlatformField: UITextField!
    @IBOutlet weak var gameGenreField: UITextField!
    @IBOutlet weak var gameDeveloperField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Delegating each textField
        self.nameField.delegate = self
        self.ageField.delegate = self
        self.gamePlatformField.delegate = self
        self.gameGenreField.delegate = self
        self.gameDeveloperField.delegate = self
        
        //MARK: Filling in text fields from plist in bundle
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
                print("Error: Keyboard Size not found")
                return
            }
            
            //Handle cases as to avoid certain fields from being pushed offscreen during landscape view
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
    
    //MARK: Misc Functions for textfields
    //Encodes data to plist while resigning the active textField
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        //Encode to plist
        DispatchQueue.main.async {
            if let currentName = self.nameField.text, let currentAge = self.ageField.text, let currentFavePlatform = self.gamePlatformField.text, let currentFaveGenre = self.gameGenreField.text, let currentGameDeveloper = self.gameDeveloperField.text {
                
                //Variables to set to plist
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
                
                print("User data file: \(self.plistURL)")
            }
        }
        
        return true
    }
    
    //Allows textFields to be marked as active to make handling easier
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
}


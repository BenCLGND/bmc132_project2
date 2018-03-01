//
//  ViewController.swift
//  bmc132_project2
//
//  Created by Clark,Benjamin on 2/21/18.
//  Copyright © 2018 Clark,Benjamin. All rights reserved.
//

import UIKit

struct appInfo : Codable {
    
    var userName: String?
    var age: String?
    var favePlatform: String?
    var faveGameGenre: String?
    var faveGameDeveloper: String?
    
}

class ViewController: UIViewController, UITextFieldDelegate {

    
    var userInput = appInfo()
    
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
            self.nameField.text = self.userInput.userName
            self.ageField.text = self.userInput.age
            self.gamePlatformField.text = self.userInput.favePlatform
            self.gameGenreField.text = self.userInput.faveGameGenre
            self.gameDeveloperField.text = self.userInput.faveGameDeveloper
            //print("Changed Fields")
        }
        
        guard let userInputURL = Bundle.main.url(forResource: "userInfo", withExtension: "plist") else {
            print("Error: Path cannot be formed")
            return
        }
        //print("\(userInputURL)")
        guard let userInputData = try? Data(contentsOf: userInputURL) else {
            print("Error: Data not found")
            return
        }
        //print(userInputData)
        guard let userInput = try? PropertyListDecoder().decode(appInfo.self, from: userInputData) else {
            print("Error: Data couldn't be retrieved from plist")
            return
        }
        
        self.userInput = userInput
        print("\(self.userInput)")
        guard let localData = try? Data(contentsOf: userInputURL) else {
            print("Error: Data not found")
            return
        }
        
        guard let localUserInputData = try? PropertyListDecoder().decode(appInfo.self, from: localData) else {
            print("Data couldn't be retrieved from plist")
            return
        }
        
        self.userInput = localUserInputData
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.nameField.resignFirstResponder()
        self.ageField.resignFirstResponder()
        self.gamePlatformField.resignFirstResponder()
        self.gameGenreField.resignFirstResponder()
        self.gameDeveloperField.resignFirstResponder()
        
        DispatchQueue.main.async {
            if let currentName = self.nameField.text {
                print("New Name: \(currentName)")
                
                self.userInput.userName = currentName
                
                let encoder = PropertyListEncoder()
                encoder.outputFormat = .xml
                do {
                    try encoder.encode(self.userInput).write(to: self.plistURL)
                    //print("written to plist")
                } catch {
                    print(error)
                }
                
                print("\(#file), \(#function), \(#line), \(self.userInput)")
                print("User Data File: \(self.plistURL)")
            }
        }
        
        return true
    }
    
    
    
}


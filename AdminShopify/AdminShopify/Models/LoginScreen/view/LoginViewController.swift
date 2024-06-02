//
//  LoginViewController.swift
//  AdminShopify
//
//  Created by Somia on 02/06/2024.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    override func viewDidLoad() {
            super.viewDidLoad()
       
        loginBtn.layer.cornerRadius = loginBtn.frame.height / 2
        Username.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        Password.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        Username.layer.borderColor = UIColor.gray.cgColor
        Username.layer.borderWidth = 1.0
        Username.layer.cornerRadius = 10
        Password.layer.borderColor = UIColor.gray.cgColor
        Password.layer.borderWidth = 1.0
        Password.layer.cornerRadius = 10

        }
    }

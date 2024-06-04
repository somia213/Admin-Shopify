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
        let userIconImageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 20, height: 20))
        userIconImageView.image = UIImage(named: "computer-icons-user-profile-head-ico-download")
        let iconContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        iconContainerView.addSubview(userIconImageView)
        Username.leftView = iconContainerView
        Username.leftViewMode = .always
        
        
        Password.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        let lockIconImageView = UIImageView(frame: CGRect(x: 10, y: 100, width: 20, height: 20))
        lockIconImageView.image = UIImage(named: "lock")
        let iconContainerView2 = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        iconContainerView.addSubview(lockIconImageView)
        Password.leftView = iconContainerView2
        Password.leftViewMode = .always
        
        Username.layer.borderColor = UIColor.gray.cgColor
        Username.layer.borderWidth = 1.0
        Username.layer.cornerRadius = 10
        Password.layer.borderColor = UIColor.gray.cgColor
        Password.layer.borderWidth = 1.0
        Password.layer.cornerRadius = 10
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        if Username.text == "admin" && Password.text == "1234" {
            
            let tabBarVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "tabBar") as! UITabBarController

            tabBarVC.modalPresentationStyle = .fullScreen
            tabBarVC.modalTransitionStyle = .crossDissolve
            self.present(tabBarVC, animated: true)
        } else {
            let alert = UIAlertController(title: "Login Failed", message: "Username or Password is incorrect", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
}

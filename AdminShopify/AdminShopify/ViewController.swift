//
//  ViewController.swift
//  AdminShopify
//
//  Created by Somia on 01/06/2024.
//

import UIKit
import Lottie

class ViewController: UIViewController {

 
    @IBOutlet weak var onboardingLottieView: AnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        onboardingLottieView.contentMode = .scaleAspectFit
        onboardingLottieView.loopMode = .loop
        onboardingLottieView.play()
        
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(changeVC), userInfo: nil, repeats: false)
    }

    @objc func changeVC(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
    }

}


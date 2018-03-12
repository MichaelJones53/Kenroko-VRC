//
//  IntroMessageViewController.swift
//  Kenroko VRC
//
//  Created by Michael Jones on 1/13/18.
//  Copyright © 2018 Kenroko. All rights reserved.
//

import UIKit
import Firebase

class IntroMessageViewController: UIViewController {
    
    var showAgain = true
    
    @IBOutlet weak var dontShowButton: UIButton!
    
    
    @IBOutlet weak var closeXButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var containingView: UIView!
    @IBAction func dontShowClicked(_ sender: UIButton) {
        
        if(showAgain){
            sender.setTitle("✔️", for: .normal)
            
            
        }else{
            sender.setTitle(" ", for: .normal)
        }
        showAgain = !showAgain
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupClickBox()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func closeClicked(_ sender: UIButton) {
        
        if(!showAgain){
            updateUserShowPromptChoice()
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func updateUserShowPromptChoice(){
        UserDefaults.standard.set(false, forKey: "showPrompt")
    }
    
    
    private func setupClickBox(){
        dontShowButton.layer.borderColor = UIColor.black.cgColor
        dontShowButton.layer.borderWidth = 1
        dontShowButton.layer.cornerRadius = 5
        containingView.layer.cornerRadius = 20
        closeButton.layer.cornerRadius = 10
        closeXButton.layer.cornerRadius = 10
        
    }
}

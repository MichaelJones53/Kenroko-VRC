//
//  ViewController.swift
//  Kenroko VRC
//
//  Created by Michael Jones on 12/5/17.
//  Copyright © 2017 Kenroko. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var ref: DatabaseReference!
    var handle: AuthStateDidChangeListenerHandle?
    let util = ViewControllerUtils()
    
    //********ACTION METHODS***********
    @IBAction func requestLogin(_ sender: UIButton) {
        //TODO: write login user
        if(!Validator.validateEmail(email: emailTextField.text!)){
            displayError(error: "invalid email address")
        }else if(!Validator.validatePassword(password: passwordTextField.text!)){
            displayError(error: "password must be at least 6 characters")
        }else{
            util.showActivityIndicator(uiView: self.view)
            
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error != nil {
                    self.util.hideActivityIndicator(uiView: self.view)
                    self.displayError(error: "Invalid Credentials")
                    return
                }
                
                UserDefaults.standard.set(true, forKey: "showPrompt")
                
                if let userID = user?.uid{
                    
                    self.ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                        let userData = snapshot.value as? NSDictionary
                        
                        if let oauthToken = userData?["runSignUpOauthToken"] as? String, let oauthSecretToken = userData?["runSignUpOauthSecret"] as? String{
                            //add token to user defaults
                            UserDefaults.standard.set(oauthToken, forKey: "oauthToken")
                            UserDefaults.standard.set(oauthSecretToken, forKey: "oauthSecretToken")
                        }else{
                            self.displayError(error: "Something Went Wrong...")
                            do{
                            try Auth.auth().signOut()
                            }catch{
                                
                            }
                        }
                    })
                    
                    
                    
                }
                
                
                
                
                
                
                
                
                self.util.hideActivityIndicator(uiView: self.view)
            }
        }
        
        
    }
    @IBAction func resetPassword(_ sender: UIButton) {
        //TODO: write reset password
        if let email = emailTextField.text{
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                // ...
                if(email.count < 1){
                    self.displayError(error: "Enter your email address to reset password")
                    
                }
                
                if let _ = error{
                    self.displayError(error: "Invalid or unregistered email address")
                    
                }else{
                    let alertController = UIAlertController(title: "Password Reset", message:
                        "An email will be sent to \(email) with reset directions", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            
        }
    }
    
    @IBAction func showTermsAndConditions(_ sender: UIButton) {
        //TODO:  write show T's&C's
        
        
    }
    
    //***************VIEW METHODS***************
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        addKeyboardRelease()
        // Do any additional setup after loading the view, typically from a nib.
        
        let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
        statusBar?.backgroundColor = UIColor.clear
    }
    
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        styleButtons()
        addImageLeftTextField(toTextField: emailTextField, withImage: "email_image.png")
        addImageLeftTextField(toTextField: passwordTextField, withImage: "password_image.png")
        styleNavigation()
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // TODO...
            if let _ = user{
                RunSignUp.setCredentials()
                
                self.performSegue(withIdentifier: "segueToMainMenu", sender: nil)
                //                do{
                //                    try auth.signOut()
                //
                //                }catch{
                //
                //                }
                
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //***********MY METHODS*********************
    
    
    //set custom UIView stylings
    func styleButtons(){
        loginButton.layer.cornerRadius = 7
        
    }
    
    // style navigation
    func styleNavigation(){
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    // fades in error label
    func displayError(error: String){
        self.errorLabel.alpha = 0
        self.errorLabel.text = error
        UIView.animate(withDuration: 1.0) {
            self.errorLabel.alpha = 1
        }
    }
    
    func clearError(){
        errorLabel.alpha = 0
    }
}


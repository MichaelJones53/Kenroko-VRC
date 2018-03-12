//
//  EmailAndPassViewController.swift
//  Kenroko VRC
//
//  Created by Michael Jones on 12/10/17.
//  Copyright © 2017 Kenroko. All rights reserved.
//

import UIKit
import Firebase

class EmailAndPassViewController: UIViewController{
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var linkRunSignUpButton: UIButton!
    
    var isLinked = false
    var newUser = UserProfile()
    let util = ViewControllerUtils()
    var ref: DatabaseReference!
    
    var sessionOpen = false
    
    @IBAction func linkRunSignUpClicked(_ sender: UIButton) {
        
        if(!sessionOpen){
            self.sessionOpen = true
            RunSignUp.authorize(completion: { (credentials) in
                self.newUser.runSignUpOauthToken = credentials.oauthToken
                self.newUser.runSignUpOauthSecret = credentials.oauthTokenSecret
                
                //add token to user defaults
                UserDefaults.standard.set(credentials.oauthToken, forKey: "oauthToken")
                UserDefaults.standard.set(credentials.oauthTokenSecret, forKey: "oauthSecretToken")
                
                RunSignUp.setCredentials(withToken: credentials.oauthToken, withSecret: credentials.oauthTokenSecret)
                
                //get user
                RunSignUp.getRunSignUpUser(success: { (userData) in
                    //parse info and store in newUser
                    let userParser = RunSignUpUserParser()
                    userParser.parseUserResults(toUser: self.newUser, withResults: userData)

                    self.isLinked = true
                    
                }, failure: { (err) in
                    
                    self.displayError(error: "An Error Has Occured")
                })
                
            }) { (error) in
                RunSignUp.shared.oauthswift.removeCallbackNotificationObserver()
                self.displayError(error: error)
                print(error)
            }
            
        }else{
            sessionOpen = false
        }
    }
    var password: String?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addMenuButton(title: "Next")
        addImageLeftTextField(toTextField: emailTextField, withImage: "email_image.png")
        addImageLeftTextField(toTextField: passwordTextField, withImage: "password_image.png")
        addImageLeftTextField(toTextField: confirmPasswordTextField, withImage: "password_image.png")
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardRelease()
        ref = Database.database().reference()
        linkRunSignUpButton.layer.cornerRadius = 7
        styleNavigation(title: "Registration")
        self.navigationController?.navigationBar.isHidden = false;
    }
    
    
    @objc override func submitAction(_ sender:UIBarButtonItem!){
        
        // check fields are proper
        if(!Validator.validateEmail(email: emailTextField.text!)){
            displayError(error: "Invalid email address")
        }else if(!Validator.validatePassword(password: passwordTextField.text!)){
            displayError(error: "Invalid password.  Must be at least 6 characters")
        }else if(!Validator.validateSamePassoword(password: passwordTextField.text!, confirmPassword: confirmPasswordTextField.text!)){
            displayError(error: "Passwords do not match")
        }else if(!isLinked){
            displayError(error: "Please link your RunSignUp account")
        }else{
            util.showActivityIndicator(uiView: self.view)
            newUser.email = emailTextField.text!
            
            Auth.auth().fetchProviders(forEmail: emailTextField.text!, completion: { (providers, errors) in
                self.util.hideActivityIndicator(uiView: self.view)
                if let error = errors{
                    print(error.localizedDescription)
                }
                
                if let _ = providers{
                    self.displayError(error: "email already exists")
                }else{
                    //add user to firebase
                    
                        //launch next screen
                        self.util.showActivityIndicator(uiView: self.view)
                    Auth.auth().createUser(withEmail: self.newUser.email!, password: self.passwordTextField.text!) { (user, error) in
                            if let error = error{
                                self.displayError(error: error.localizedDescription)
                                
                            }else{
                                UserDefaults.standard.set(true, forKey: "showPrompt")
                                //create DB field for user
                                let userRef = self.ref.child("users").child((user?.uid)!)
                                let userData = self.newUser.dictionaryOfUser()
                        
                                userRef.setValue(userData, withCompletionBlock: { (error, database) in
                                    if let e = error{
                                        print(e.localizedDescription)
                                        self.errorLabel.text = "An error has occured. Please try again."
                                    }else{
                                        self.util.hideActivityIndicator(uiView: self.view)
                                        
                                        self.performSegue(withIdentifier: "segueToMainScreen", sender: nil)
                                    }
                                })
                            }
                            self.util.hideActivityIndicator(uiView: self.view)
                        }
                    
                    
                }
            })
            
        }
        
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

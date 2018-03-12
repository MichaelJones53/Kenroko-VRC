//
//  ProfileViewController.swift
//  Kenroko VRC
//
//  Created by Michael Jones on 12/23/17.
//  Copyright © 2017 Kenroko. All rights reserved.
//

import UIKit
import Firebase


class ProfileViewController: UIViewController{
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    var ref: DatabaseReference!
    var utils = ViewControllerUtils()
    
    
    
    @IBAction func logOutClicked(_ sender: UIButton) {
        print("log out clicked");
        // log out user
        signOut()
        //launch login screen
        performSegue(withIdentifier: "segueLoginScreen", sender: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        print("viewwillappear entered and ended")
    }
    
    override func viewDidLoad() {
        styleNavigation()
        styleProfileImageView()
        
        
        ref = Database.database().reference()
        
        if let curUser = Auth.auth().currentUser{
            //utils.showActivityIndicator(uiView: self.view)
            print("curUser entered")
            let userID = curUser.uid
            ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                let userData = snapshot.value as? NSDictionary
                let firstName = userData?["firstName"] as? String ?? "unknown"
                let lastName = userData?["lastName"] as? String ?? ""
                let code = userData?["CountryCode"] as? String ?? "US"
                
               
                //get user runsignup data
                
                RunSignUp.getRunSignUpUser(success: { (results) in
                    let userParser = RunSignUpUserParser()
                    let temp = UserProfile()
                    userParser.parseUserResults(toUser: temp, withResults: results)
                    
                    let userRef = self.ref.child("users").child((Auth.auth().currentUser?.uid)!)
                    
                    userRef.updateChildValues(["profileImage":temp.profileImage!])
                    
                }, failure: { (string) in
                    print(string)
                })
               
               let profilePic = userData?["profileImage"] as? String ?? ""
                
                
                
                let name = "\(firstName) \(lastName)"
                
                self.nameLabel.text = name
                self.countryLabel.text = String(self.countryCodeAsEmoji(countryCode: code))
                
                if(profilePic != "https://runsignup.com/static/img/runnerGray.png"){
                    let session = URLSession(configuration: .default)
                    session.dataTask(with: URL(string: profilePic)!, completionHandler: { (data, response, error) in
                        
                        if let e = error{
                            print(e.localizedDescription)
                        }else{
                            if let imageData = data{
                                DispatchQueue.main.async {
                                    self.profileImageView.image = UIImage(data: imageData)
                                    
                                }
                            }
                        }
                        
                    }).resume()
                }
                self.utils.hideActivityIndicator(uiView: self.view)
            }){ (error) in
                print("error entered")
                print(error.localizedDescription)
                self.utils.hideActivityIndicator(uiView: self.view)
            }
            
        }else{
            print("nouser entered")
            nameLabel.text = "No user logged in"
            utils.hideActivityIndicator(uiView: self.view)
        }
    }
    
    func signOut(){
        let firebaseUser = Auth.auth()
        do{
            try firebaseUser.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    // style navigation
    func styleNavigation(){
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func styleProfileImageView(){
        profileImageView.layer.borderWidth = 1
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.layer.backgroundColor = UIColor.white.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height/1.7
        profileImageView.clipsToBounds = true
        
    }
    
    func loadRegisteredRaceData(){
        
        
    }
    
    
    
}

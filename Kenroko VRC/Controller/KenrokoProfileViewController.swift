//
//  KenrokoProfileViewController.swift
//  Kenroko VRC
//
//  Created by Michael Jones on 3/11/18.
//  Copyright © 2018 Kenroko. All rights reserved.
//

import UIKit
import Firebase

class KenrokoProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "raceResultsCell", for: indexPath) as! UserRaceResultsCell
        
//        cell.nameLabel.text = "\(currentResult.firstName) \(currentResult.lastName)"
//        cell.timeLabel.text = "\(currentResult.clockTime)"
//        cell.flagLabel.text = String(countryCodeAsEmoji(countryCode: currentResult.country))
        
        
        return cell
    }
    
    

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userFlagLabel: UILabel!
    
    @IBOutlet weak var userProfilePictureImageView: UIImageView!
    
    @IBOutlet weak var userRaceHistoryTableView: UITableView!
    
    
    var ref: DatabaseReference!
    var utils = ViewControllerUtils()
    
    
    
    
    var raceResults = [RaceResult]()
    
    @IBAction func LogoutButtonClicked(_ sender: UIButton) {
        print("log out clicked");
        // log out user
        signOut()
        //launch login screen
        performSegue(withIdentifier: "segueLoginScreen", sender: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleLayout();
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadUserData()
        loadRegisteredRaceData()
        
        
        
        //TODO: dismiss loading wheel
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    func signOut(){
        let firebaseUser = Auth.auth()
        do{
            try firebaseUser.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    func styleLayout(){
        userRaceHistoryTableView.layer.cornerRadius = 10
        
        //userProfilePictureImageView.layer.borderWidth = 1
        userProfilePictureImageView.layer.masksToBounds = false
        //userProfilePictureImageView.layer.borderColor = UIColor.white.cgColor
        //userProfilePictureImageView.layer.backgroundColor = UIColor.white.cgColor
        userProfilePictureImageView.layer.cornerRadius = userProfilePictureImageView.frame.height/1.7
        userProfilePictureImageView.clipsToBounds = true
    }
    
    func loadRegisteredRaceData(){
        //TODO: show loading wheel in tableview
        //get user race results
        var registeredRaces = [RegisteredRaceProfile]()
        RunSignUp.runSignUpGetRegisteredRaces { (regResults) in
            //parse results
            //print(regResults)
            let parser = RunSignUpRegisteredRaceParser()
            
            
            //add to tableData
            registeredRaces = parser.getRaces(withXML: regResults)
            
            
            var raceDict = [String: RaceProfile]()
            
           
            
            RunSignUp.getKenrokoRaces(success: { (racesResults) in
                let par = RunSignUpRaceParser()
                
                let results = par.getRaces(withXML: racesResults)
                for race in results{
                    raceDict[race.eventID!] = race
                }
                
                
                for race in registeredRaces{
                    if let _ = raceDict[race.eventID!]{
                        
                        
                        RunSignUp.runSignUpGetRaceResults(withRaceID: Int(race.raceID!)!, withEventID: Int(race.eventID!)!, success: { (raceRes) in
                            let p = RunSignUpUserRaceResultParser()
                            let temp = p.getResult(withID: Int(race.registrationID!)!, withXML: raceRes)
                            
                            temp.raceName = raceDict[race.eventID!]?.raceName
                            print("\(temp.racePosition) : \(temp.raceName)")
                            
                            if let _ = temp.raceName, let _ = temp.racePace, let _ = temp.clockTime, let _ = temp.racePosition{
                                
                                print("-----\(temp.raceName!)")
                                
                                self.raceResults.append(temp)
                                
                            }
                            
                            
                            
                        }, failure: { (failure) in
                            print(failure)
                        })
                    }
                        
                    }
                    
                    
                
                
                
            }, failure: { (error) in
                
                print(error)
            })
            
            
            
            //update table
            self.reloadTable()
        }
        
        
        
        
        
        
    }
    
    func reloadTable(){
        
    }
    
    
    func loadUserData(){
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

                self.userNameLabel.text = name
                self.userFlagLabel.text = String(self.countryCodeAsEmoji(countryCode: code))

                if(profilePic != "https://runsignup.com/static/img/runnerGray.png"){
                    let session = URLSession(configuration: .default)
                    session.dataTask(with: URL(string: profilePic)!, completionHandler: { (data, response, error) in

                        if let e = error{
                            print(e.localizedDescription)
                        }else{
                            if let imageData = data{
                                DispatchQueue.main.async {
                                    self.userProfilePictureImageView.image = UIImage(data: imageData)

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
            userNameLabel.text = "No user logged in"
            utils.hideActivityIndicator(uiView: self.view)
        }
    }
}

class UserRaceResultsCell: UITableViewCell{
    
    @IBOutlet weak var raceTitle: UILabel!
    @IBOutlet weak var raceTime: UILabel!
    @IBOutlet weak var racePace: UILabel!
    
    
    
}

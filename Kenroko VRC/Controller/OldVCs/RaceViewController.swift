//
//  RaceViewController.swift
//  Kenroko VRC
//
//  Created by Michael Jones on 1/13/18.
//  Copyright © 2018 Kenroko. All rights reserved.
//

import UIKit
import Firebase
import OAuthSwift


class RaceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return kenrokoRaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RaceTableViewCell
        let race = kenrokoRaces[indexPath.item]
        cell.raceNameLabel.text = race.name
        
        cell.registerButton.layer.cornerRadius = 10
        
        return cell
    }
    
    @IBOutlet weak var tableView: UITableView!
    var kenrokoRaces = [RunSignUpRace]()
    var ref: DatabaseReference!
    var userID: String?
    var utils = ViewControllerUtils()
    let runSignUp = RunSignUp.shared

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //load upcoming races
        
        
        //check if user is registered for them
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTable()
        ref = Database.database().reference()
        
        let defaults = UserDefaults.standard
        let shouldShowPrompt = defaults.bool(forKey: "showPrompt")
        RunSignUp.setCredentials(withToken: defaults.string(forKey: "oauthToken")!, withSecret: defaults.string(forKey: "oauthSecretToken")!)

        if(shouldShowPrompt){
            self.performSegue(withIdentifier: "showIntroMessage", sender: nil)
        }
 
    }
    
    func updateTable(){
        //TODO:  Get list of all races
        
        RunSignUp.getUpcommingKenrokoRaces(success: { (results) in
            //parse the results and add to kenrokoraces list
            let parser = RunSignUpRaceParser();
            let upcommingRaces = parser.getRaces(withXML: results)
           
            RunSignUp.runSignUpGetRegisteredRaces(completion: { (results) in
                print("+++RegisteredRaces+++")
                let regParser = RunSignUpRegisteredRaceParser()
                let regRaces = regParser.getRaces(withXML: results)
                
                for race in upcommingRaces{
                    
                    
                    let tempRace = RunSignUpRace()
                    tempRace.name = race.raceName
                    tempRace.raceID = Int(race.raceID!)
                    tempRace.eventID = Int(race.eventID!)
                    
                    
                    for regRace in regRaces{
                        if let upRace = race.eventID, let regEvent = regRace.eventID{
                            if(upRace == regEvent){
                                tempRace.isRegistered = true
                                
                            }
                        }
                    
                    }
                    self.kenrokoRaces.append(tempRace)
                }
                
                self.refreshTable()
                
            })
            //TODO: get list of all user registered races
            RunSignUp.runSignUpGetRegisteredRaces(completion: { (results) in
                
            })
            
            //TODO:  set tableview accordingly
            
            
        }) { (error) in
            
            
        }
        
        
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func refreshTable()
    {
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    
    }
}

class RaceTableViewCell: UITableViewCell{
    
    @IBOutlet weak var raceNameLabel: UILabel!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBAction func registerButtonClicked(_ sender: UIButton) {
        if(sender.title(for: .normal) == "Register"){
            print("send to register")
        }else{
            print("launch run tool")
        }
        
        
    }
}


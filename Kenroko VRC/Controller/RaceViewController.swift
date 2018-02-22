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


class RaceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, XMLParserDelegate {
    
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
    let runSignUp = RunSignUp()
    
    var isParsingRaces = false
    var isParsingUserRegistration = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        if let curUser = Auth.auth().currentUser{
            ref.child("users").child(curUser.uid).observeSingleEvent(of: .value, with: {(snapshot) in
                let value = snapshot.value as? NSDictionary
                let shouldShowPrompt = value?["ShowPrompt"] as? Bool ?? true
                let token = value?["runSignUpOauthToken"] as? String ?? ""
                let secret = value?["runSignUpOauthSecret"] as? String ?? ""
                
                self.runSignUp.setCredentials(withToken: token, withSecret: secret)
                self.updateTable()
                if(shouldShowPrompt){
                    self.performSegue(withIdentifier: "showIntroMessage", sender: nil)
                }
            })
        }
        
        ref.child("races").observeSingleEvent(of: .value) { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            for race in value!{
                let newRace = RunSignUpRace()
                
                let eventData = race.value as? NSDictionary
                let eventID = eventData?["eventID"] as? String ?? ""
                let raceID = eventData?["raceID"] as? String ?? ""
                
                newRace.name = race.key as? String ?? ""
                newRace.eventID = Int(eventID)!
                newRace.raceID = Int(raceID)!
                
                self.kenrokoRaces.append(newRace)
                
            }
            
            self.runSignUp.runSignUpGetRegisteredRaces(completion: { (results) in
                
                //parse race results
                print(results)
                
                
                self.refreshTable()
            })
            
            
        }
    }
    
    func updateTable(){
        //TODO:  Get list of all races

        //TODO: get list of all user registered races
        
        //TODO:  set tableview accordingly
        
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
    
    //*******PARSER FUNCTIONS****************
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        
        
    }
    
    // found characters
    //
    // - If this is an element we care about, append those characters.
    // - If `currentValue` still `nil`, then do nothing.
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        
        
    }
    
    // end element
    //
    // - If we're at the end of the whole dictionary, then save that dictionary in our array
    // - If we're at the end of an element that belongs in the dictionary, then save that value in the dictionary
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        
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


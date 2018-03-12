//
//  GoalsViewController.swift
//  Kenroko VRC
//
//  Created by Michael Jones on 12/22/17.
//  Copyright © 2017 Kenroko. All rights reserved.
//

import UIKit
import Firebase

class GoalsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, XMLParserDelegate{
    
    let runSignUp = RunSignUp.shared
    
    var raceResults = [RaceResult]()
    var tempRaceResult = RaceResult()
    var foundCharacters = ""
    var ref: DatabaseReference!
    var utils = ViewControllerUtils()
    
    @IBOutlet weak var noRaceLabel: UILabel!
    @IBOutlet weak var donationProgressBar: UIProgressView!
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return raceResults.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RankingTableViewCell
        let currentResult = raceResults[indexPath.item]
        
        cell.nameLabel.text = "\(currentResult.firstName) \(currentResult.lastName)"
        cell.timeLabel.text = "\(currentResult.clockTime)"
        cell.flagLabel.text = String(countryCodeAsEmoji(countryCode: currentResult.country))
        
        
        return cell
    }
    
    @IBAction func donateClicked(_ sender: UIButton) {
        
        UIApplication.shared.openURL(NSURL(string: "https://www.paypal.me/Kenroko")! as URL)
    }
    
    
    
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBAction func instagramLinkClicked(_ sender: UIButton) {
        let instagramHooks = "instagram://tag?name=kenroko5k"
        let instagramUrl = NSURL(string: instagramHooks)
        if UIApplication.shared.canOpenURL(instagramUrl! as URL) {
            UIApplication.shared.openURL(instagramUrl! as URL)
        } else {
            //redirect to safari because the user doesn't have Instagram
            UIApplication.shared.openURL(NSURL(string: "http://instagram.com/explore/tags/kenroko5k/")! as URL)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppearCalled")
        donationProgressBar.animate(duration: 1.5, toValue: 0.85)
        
    }
    
    
    
    override func viewDidLoad() {
        RunSignUp.setCredentials(withToken: UserDefaults.standard.string(forKey: "oauthToken")!, withSecret: UserDefaults.standard.string(forKey: "oauthSecretToken")!)
        ref = Database.database().reference()
        donationProgressBar.setProgress(0.0, animated: false)
        monthLabel.text = Date().getMonthName()
        
        styleNavigation()
        getCurrentRaceResults()
        
        NotificationCenter.default.addObserver(self, selector: #selector(viewDidBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        
    }
    
    @objc func viewDidBecomeActive(){
        
        print("view became active")
    }
    
    
    // style navigation
    func styleNavigation(){
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func getCurrentRace(success: @escaping (RunSignUpRace)->()){
        
        ref.child("currentRace").observeSingleEvent(of: .value) { (snapshot) in
            if let raceData = snapshot.value as? NSDictionary{
                
               
                let name = raceData["name"] as? String ?? ""
                let eventID = raceData["eventID"] as? Int ?? 0
                let raceID = raceData["raceID"] as? Int ?? 0
                
                let currentRace = RunSignUpRace()
                currentRace.eventID = eventID
                currentRace.name = name
                currentRace.raceID = raceID
                success(currentRace)
            }
        }
        
        
        
        
    }
    
    func getCurrentRaceResults(){
        getCurrentRace { (currentRace) in

            
            RunSignUp.runSignUpGetRaceResults(withRaceID: 50387/*currentRace.raceID!*/, withEventID: 181658/*currentRace.eventID!*/, success: { (results) in
                //parse the XML into participant information
                self.parseRaceResults(withResults: results)
                
                //refresh datatable
                self.refreshTable()
                
            }) { (error) in
                
                //set datatable to display a row that says error
                
                
                
            }
            
        }
        
        
        
    }
    
    var parseField = ""
    var shouldSetParseField = false
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if(elementName == "name"){
            shouldSetParseField = true
        }
        
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        
        if(elementName == "value"){
            if parseField == "first_name"{
                self.tempRaceResult.firstName = self.foundCharacters
                
            }
            
            if parseField == "last_name"{
                self.tempRaceResult.lastName = self.foundCharacters
                
            }
            if parseField == "country_code"{
                self.tempRaceResult.country = self.foundCharacters
                
                
            }
            if parseField == "clock_time"{
                self.tempRaceResult.clockTime = self.foundCharacters
                
                
                
            }
            
            parseField = ""
            
        }
        
        if elementName == "result"{
            
            self.raceResults.append(tempRaceResult)
            tempRaceResult = RaceResult()
        }
        
        foundCharacters = ""
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        if(shouldSetParseField){
            self.parseField = string
            shouldSetParseField = false
        }else{
            self.foundCharacters = string
        }
        
    }
    
    
    private func parseRaceResults(withResults results: String){
        let xmlData = results.data(using: String.Encoding.utf8)
        let parser = XMLParser(data: xmlData!)
        
        parser.delegate = self
        
        parser.parse()
        
    }
    
    
    private func refreshTable()
    {
        if(raceResults.count == 0){
            tableView.isHidden = true
            noRaceLabel.isHidden = false
            
        }else{
            tableView.isHidden = false
            noRaceLabel.isHidden = true
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
}




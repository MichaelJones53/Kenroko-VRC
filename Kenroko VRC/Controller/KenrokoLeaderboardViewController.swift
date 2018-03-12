//
//  KenrokoLeaderboardViewController.swift
//  Kenroko VRC
//
//  Created by Michael Jones on 3/11/18.
//  Copyright © 2018 Kenroko. All rights reserved.
//

import UIKit
import Firebase

class KenrokoLeaderboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, XMLParserDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("numRows called")
        if(raceResults.count == 0){
            return 1
        }
        return raceResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RankingTableViewCell
        
        
        print("asdf----\(raceResults.count)")
        if(raceResults.count == 0){
            
            cell.nameLabel.text = "Be the first to run this month!"
            cell.nameLabel.center.x = self.view.center.x
            cell.timeLabel.text = ""
            cell.flagLabel.text = ""
            
        }else{
            let currentResult = raceResults[indexPath.item]
            cell.nameLabel.text = "\(indexPath.item+1)) \(currentResult.firstName!) \(currentResult.lastName!)"
            cell.timeLabel.text = "\(currentResult.clockTime!)"
            cell.flagLabel.text = String(countryCodeAsEmoji(countryCode: currentResult.country))

        }
        
       return cell
    }
    

    @IBOutlet weak var rankingLabel: UILabel!
    
    @IBOutlet weak var rankingTableView: UITableView!
    
    
    
    var raceResults = [RaceResult]()
    var tempRaceResult = RaceResult()
    var foundCharacters = ""
    var ref: DatabaseReference!
    var utils = ViewControllerUtils()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        rankingLabel.text = "\(Date().getMonthName()) Rankings"
        rankingTableView.layer.cornerRadius = 10
        refreshTable()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rankingTableView.reloadData()
        getCurrentRaceResults()
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    var parseField = ""
    var shouldSetParseField = false
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if(elementName == "name"){
            shouldSetParseField = true
        }
        
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        print("didEndElement called")
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
        print("parsing began")
        parser.parse()
         print("parsing ended")
        print(raceResults.count)
    }
    
    func getCurrentRaceResults(){
        RunSignUp.getUpcommingKenrokoRaces(success: { (result) in
        let raceParse = RunSignUpRaceParser()
        let race = raceParse.getRaces(withXML: result)
            
            
            
            RunSignUp.runSignUpGetRaceResults(withRaceID: Int((race.last?.raceID)!)!, withEventID: Int((race.last?.eventID)!)!, success: { (results) in
                //parse the XML into participant information
                self.parseRaceResults(withResults: results)

                //refresh datatable
                self.refreshTable()

            }) { (fail) in
                print(fail)
            }


        }) { (err) in
            print(err)
        }
        
        
        
       
        
    }
    
    private func refreshTable()
    {
        print("called")
        DispatchQueue.main.async {
            self.rankingTableView.reloadData()
        }
    }
}

class RankingTableViewCell: UITableViewCell{
    @IBOutlet weak var flagLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
}
// style navigation
//func styleNavigation(){
//    self.navigationController?.navigationBar.isHidden = true
//    self.navigationController?.navigationBar.isTranslucent = true
//}

//func getCurrentRace(success: @escaping (RunSignUpRace)->()){
//
//    ref.child("currentRace").observeSingleEvent(of: .value) { (snapshot) in
//        if let raceData = snapshot.value as? NSDictionary{
//
//
//            let name = raceData["name"] as? String ?? ""
//            let eventID = raceData["eventID"] as? Int ?? 0
//            let raceID = raceData["raceID"] as? Int ?? 0
//
//            let currentRace = RunSignUpRace()
//            currentRace.eventID = eventID
//            currentRace.name = name
//            currentRace.raceID = raceID
//            success(currentRace)
//        }
//    }



extension UIProgressView {
    
    func animate(duration: Double, toValue: Float) {

        self.setProgress(0.01, animated: false)

        UIView.animate(withDuration: duration, delay: 1.5, options: .curveEaseInOut, animations: {
            self.setProgress(toValue, animated: true)
        }, completion: nil)
    }
}


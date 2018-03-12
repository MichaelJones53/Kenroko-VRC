//
//  KenrokoRaceViewController.swift
//  Kenroko VRC
//
//  Created by Michael Jones on 3/11/18.
//  Copyright © 2018 Kenroko. All rights reserved.
//

import UIKit

class KenrokoRaceViewController: UIViewController {

    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var raceLabel: UILabel!
    
    @IBOutlet weak var donateButton: UIButton!
    @IBOutlet weak var raceButton: UIButton!
    @IBAction func raceButtonClicked(_ sender: UIButton) {
    
        if(isRegistered){
            //launch run screen
            
            
        }else{
           //take to registration page
            UIApplication.shared.openURL(NSURL(string: (curRace?.raceUrlAsString)!)! as URL)
        }

    }
    
    @IBAction func donateButtonClicked(_ sender: UIButton) {
        UIApplication.shared.openURL(NSURL(string: "https://www.paypal.me/Kenroko")! as URL)
    }
    
    @objc func viewDidBecomeActive(){
        updateRegistrationStatus()
        print("view became active")
    }
    
    var isRegistered = false
    var curRace: RaceProfile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(viewDidBecomeActive), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        styleLayout()
        // Do any additional setup after loading the view.
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        //check if user is registerd for this months race
        updateRegistrationStatus()
    }
    func updateRegistrationStatus(){
        raceButton.isEnabled = false
        RunSignUp.runSignUpGetRegisteredRaces { (regRaceResults) in
            let regParser = RunSignUpRegisteredRaceParser()
            let regRaces = regParser.getRaces(withXML: regRaceResults)
            
            RunSignUp.getUpcommingKenrokoRaces(success: { (currentRaceResults) in
                let curRaceParser = RunSignUpRaceParser()
                self.curRace = curRaceParser.getRaces(withXML: currentRaceResults).last
                
                self.raceLabel.text = self.curRace?.raceName
                
                for race in regRaces{
                    if(race.eventID == self.curRace?.eventID){
                        self.isRegistered = true
                        self.raceButton.setTitle("Race", for: .normal)
                    }
                }
                self.raceButton.isEnabled = true
                
            }, failure: { (err) in
                print(err)
            })
            
        }
    }
    func styleLayout(){
        donateButton.layer.cornerRadius = 5
        raceButton.layer.cornerRadius = 5
        monthLabel.text = "- \(Date().getMonthName()) -"
    }
}

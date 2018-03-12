//
//  RunSignUpRegisteredRaceParser.swift
//  Kenroko VRC
//
//  Created by Michael Jones on 3/2/18.
//  Copyright © 2018 Kenroko. All rights reserved.
//

import Foundation

class RunSignUpRegisteredRaceParser: XMLParser, XMLParserDelegate{
    
    var allRegisteredRaces = [RegisteredRaceProfile]()
    var tempRace = RegisteredRaceProfile()
    
    
    //Parse Races
    public func getRaces(withXML results: String)->[RegisteredRaceProfile]{
        allRegisteredRaces = [RegisteredRaceProfile]()
        tempRace = RegisteredRaceProfile()
        let xmlData = results.data(using: String.Encoding.utf8)
        let parser = XMLParser(data: xmlData!)
            
        parser.delegate = self
        parser.parse()
        
        for race in allRegisteredRaces{
            if(race.eventID == "181658"){
                
            }
        }
        
        return allRegisteredRaces
    }
    
    //*************XMLPARSER Delegate functions/vars******************
    var foundCharacters = ""
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

    }


    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {


        if(elementName == "registration_id"){
            tempRace.registrationID = foundCharacters

        }else if(elementName == "registration_date"){
            tempRace.registrationDate = foundCharacters
        }
        else if(elementName == "race_id"){
            tempRace.raceID = foundCharacters
        }else if(elementName == "event_id"){
            tempRace.eventID = foundCharacters
        }else if(elementName == "amount_paid"){
            tempRace.amountPaid = foundCharacters
        }else if(elementName == "registered_race"){
        //    if(tempRace.eventID != "181658"){
                allRegisteredRaces.append(tempRace)
          //  }
            tempRace = RegisteredRaceProfile()
        }

        foundCharacters = ""
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {

        self.foundCharacters = string
    }

}

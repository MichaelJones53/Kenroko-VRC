//
//  RunSignUpRaceParser.swift
//  Kenroko VRC
//
//  Created by Michael Jones on 2/28/18.
//  Copyright © 2018 Kenroko. All rights reserved.
//

import Foundation

class RunSignUpRaceParser: XMLParser, XMLParserDelegate{
    
    var allRaces = [RaceProfile]()
    var tempRace = RaceProfile()
    
    var isInEvent = false
    
    //Parse Races
    public func getRaces(withXML results: String)->[RaceProfile]{
        allRaces = [RaceProfile]()
        tempRace = RaceProfile()
        let xmlData = results.data(using: String.Encoding.utf8)
        let parser = XMLParser(data: xmlData!)
        
        parser.delegate = self
        parser.parse()
        
        return allRaces
    }
    
    //*************XMLPARSER Delegate functions/vars******************
    var foundCharacters = ""
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        if(elementName == "event"){
            isInEvent = true
        }
    }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
       
        
        if(elementName == "race_id"){
            tempRace.raceID = foundCharacters
            
        }else if(elementName == "name" && !isInEvent){
            tempRace.raceName = foundCharacters
        }
        else if(elementName == "description"){
            tempRace.raceDescription = foundCharacters
        }else if(elementName == "url"){
            tempRace.raceUrlAsString = foundCharacters
        }else if(elementName == "logo_url"){
            tempRace.raceLogoUrlAsString = foundCharacters
        }else if(elementName == "is_registration_open"){
            tempRace.isRegistrationOpen = foundCharacters
        }else if(elementName == "street"){
            tempRace.street = foundCharacters
        }else if(elementName == "zipcode"){
            tempRace.zipcode = foundCharacters
        }else if(elementName == "country_code"){
            tempRace.countryCode = foundCharacters
        }else if(elementName == "city"){
            tempRace.city = foundCharacters
        }else if(elementName == "state"){
            tempRace.state = foundCharacters
        }else if(elementName == "timezone"){
            tempRace.timezone = foundCharacters
        }else if(elementName == "event_id"){
            tempRace.eventID = foundCharacters
        }else if(elementName == "details"){
            tempRace.eventDetailedDescription = foundCharacters
        }else if(elementName == "start_time"){
            tempRace.startTime = foundCharacters
        }else if(elementName == "end_time"){
            tempRace.endTime = foundCharacters
        }else if(elementName == "registration_opens"){
            tempRace.registrationOpenDateAsString = foundCharacters
        }else if(elementName == "event_type"){
            tempRace.eventType = foundCharacters
        }else if(elementName == "distance"){
            tempRace.distance = foundCharacters
        }else if(elementName == "race"){
            allRaces.append(tempRace)
            tempRace = RaceProfile()
        }
        
        if(elementName == "event"){
            isInEvent = false
        }
        
        
        foundCharacters = ""
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        foundCharacters = string
    }
    
}

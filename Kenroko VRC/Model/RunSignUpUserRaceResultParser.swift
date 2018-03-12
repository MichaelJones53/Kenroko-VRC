//
//  RunSignUpUserRaceResultParser.swift
//  Kenroko VRC
//
//  Created by Michael Jones on 3/11/18.
//  Copyright © 2018 Kenroko. All rights reserved.
//

import Foundation

class RunSignUpUserRaceResultParser: XMLParser, XMLParserDelegate{
    
    var tempResult = RaceResult()
    
    var iD = ""
    
    //Parse RaceResult
    public func getResult(withID id:Int, withXML results: String)->RaceResult{
        tempResult = RaceResult()
        let xmlData = results.data(using: String.Encoding.utf8)
        let parser = XMLParser(data: xmlData!)
        
        iD = String(id)
        
       // print(results)
        parser.delegate = self
        parser.parse()
        
        
        return tempResult
    }
    
    //*************XMLPARSER Delegate functions/vars******************
    var foundCharacters = ""
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
    }
    
    
    var foundUser = false
    var inPlace = false
    var inTime = false
    var inPace = false
    var inName = false
    
    var inRegistrationID = false
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        
        
        if(elementName == "result"){
            foundUser = false
            
        }else if(elementName == "value"){
            
            if(foundCharacters == iD){
                foundUser = true
            }
        }
        
        if(foundUser){
            
            if(elementName == "name"){
                if(foundCharacters == "place"){
                    inPlace = true;
                }
                if(foundCharacters == "clock_time"){
                    inTime = true;
                }
                if(foundCharacters == "pace"){
                    inPace = true;
                }
                if(foundCharacters == "first_name"){
                    
                    inName = true
                }
            }
            
            
            if(inPlace && elementName == "value"){
                print("in place")
                tempResult.racePosition = foundCharacters
                resetLocations()
            }
            if(inTime && elementName == "value"){
                print("in time")
                tempResult.clockTime = foundCharacters
                resetLocations()
            }
            if(inPace && elementName == "value"){
                print("in pace")
                tempResult.racePace = foundCharacters
                resetLocations()
            }
            if(inName && elementName == "value"){
                resetLocations()
            }
        }
        
        foundCharacters = ""
    }
    
    func resetLocations(){
        inPlace = false
        inTime = false
        inPace = false
        inName = false
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        self.foundCharacters = string
    }
    
}

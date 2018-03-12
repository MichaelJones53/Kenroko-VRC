//
//  RunSignUpParser.swift
//  Kenroko VRC
//
//  Created by Michael Jones on 2/24/18.
//  Copyright © 2018 Kenroko. All rights reserved.
//

import Foundation

class RunSignUpParser: XMLParser, XMLParserDelegate{
    
    
    
    
    
    //Parse Race
    
    
    //Parse User
    public func parseUserResults(withResults results: String){
        let xmlData = results.data(using: String.Encoding.utf8)
        let parser = XMLParser(data: xmlData!)
        
        parser.delegate = self
        
        parser.parse()
    }
    
    //*************XMLPARSER Delegate functions/vars******************
    var foundCharacters = ""
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
    }
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        print("found element: \(elementName)")
        
        if(elementName == "first_name"){
            self.newUser.firstName = foundCharacters
        }else if(elementName == "last_name"){
            self.newUser.lastName = foundCharacters
        }else if(elementName == "gender"){
            self.newUser.gender = foundCharacters
        }else if(elementName == "user_id"){
            self.newUser.runSignUpUserID = foundCharacters
        }else if(elementName == "street"){
            self.newUser.street = foundCharacters
        }else if(elementName == "city"){
            self.newUser.city = foundCharacters
        }else if(elementName == "state"){
            self.newUser.state = foundCharacters
        }else if(elementName == "zipcode"){
            self.newUser.zipcode = foundCharacters
        }else if(elementName == "country_code"){
            self.newUser.countryCode = foundCharacters
        }else if(elementName == "dob"){
            self.newUser.birthDate = foundCharacters
        }else if(elementName == "phone"){
            self.newUser.phone = foundCharacters
        }else if(elementName == "profile_image_url"){
            self.newUser.profileImage = foundCharacters
        }
        
        foundCharacters = ""
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        self.foundCharacters = string
    }
    
    
    
}

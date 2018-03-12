//
//  RunSignUpUserParser.swift
//  Kenroko VRC
//
//  Created by Michael Jones on 2/24/18.
//  Copyright © 2018 Kenroko. All rights reserved.
//

import Foundation

class RunSignUpUserParser: XMLParser, XMLParserDelegate{
    
    var user: UserProfile?
    
    
    //Parse User
    public func parseUserResults(toUser newUser: UserProfile, withResults results: String){
        user = newUser

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
        
        
        if(elementName == "first_name"){
            user?.firstName = foundCharacters
            
        }else if(elementName == "last_name"){
            user?.lastName = foundCharacters
        }else if(elementName == "gender"){
            user?.gender = foundCharacters
        }else if(elementName == "user_id"){
            user?.runSignUpUserID = foundCharacters
        }else if(elementName == "street"){
            user?.street = foundCharacters
        }else if(elementName == "city"){
            user?.city = foundCharacters
        }else if(elementName == "state"){
            user?.state = foundCharacters
        }else if(elementName == "zipcode"){
            user?.zipcode = foundCharacters
        }else if(elementName == "country_code"){
            user?.countryCode = foundCharacters
        }else if(elementName == "dob"){
            user?.birthDate = foundCharacters
        }else if(elementName == "phone"){
            user?.phone = foundCharacters
        }else if(elementName == "profile_image_url"){
            user?.profileImage = foundCharacters
        }
        foundCharacters = ""
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        self.foundCharacters = string
    }
    
    
    
}

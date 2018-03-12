//
//  RegisteredRaceProfile.swift
//  Kenroko VRC
//
//  Created by Michael Jones on 3/2/18.
//  Copyright © 2018 Kenroko. All rights reserved.
//

import Foundation

class RegisteredRaceProfile{
    var registrationID: String?
    var registrationDate: String?
    var raceID: String?
    var eventID: String?
    var amountPaid:String?

    func dictionaryOfRace()->[String : String]{
        var data = [String: String]()
        data["registrationID"] = registrationID
        data["registrationDate"] = registrationDate
        data["raceID"] = raceID
        data["eventID"] = eventID
        data["amountPaid"] = amountPaid
        
        return data
    }
}

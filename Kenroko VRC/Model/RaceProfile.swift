//
//  RaceProfile.swift
//  Kenroko VRC
//
//  Created by Michael Jones on 2/28/18.
//  Copyright © 2018 Kenroko. All rights reserved.
//

import Foundation

class RaceProfile{
    var raceID: String?
    var raceName: String?
    var raceDescription: String?
    var raceUrlAsString: String?
    var raceLogoUrlAsString:String?
    var isRegistrationOpen:String?
    var street: String?
    var city: String?
    var state: String?
    var zipcode: String?
    var countryCode: String?
    var timezone: String?
    var eventID: String?
    var eventDetailedDescription: String?
    var startTime: String?
    var endTime: String?
    var registrationOpenDateAsString: String?
    var eventType: String?
    var distance: String?
    
    func dictionaryOfRace()->[String : String]{
        var data = [String: String]()
        data["raceID"] = raceID
        data["raceName"] = raceName
        data["raceDescription"] = raceDescription
        data["raceUrlAsString"] = raceUrlAsString
        data["raceLogoUrlAsString"] = raceLogoUrlAsString
        data["isRegistrationOpen"] = isRegistrationOpen
        data["street"] = street
        data["city"] = city
        data["zipcode"] = zipcode
        data["state"] = state
        data["countryCode"] = countryCode
        data["timezone"] = timezone
        data["eventID"] = eventID
        data["eventDetailedDescription"] = eventDetailedDescription
        data["startTime"] = startTime
        data["endTime"] = endTime
        data["registrationOpenDateAsString"] = registrationOpenDateAsString
        data["eventType"] = eventType
        data["distance"] = distance
        return data
    }
}

//
//  UserProfile.swift
//  Kenroko VRC
//
//  Created by Michael Jones on 10/21/17.
//  Copyright © 2017 Michael Jones. All rights reserved.
//

class UserProfile {
    var firstName: String?
    var lastName: String?
    var gender: String?
    var email:String?
    var street: String?
    var city: String?
    var state: String?
    var zipcode: String?
    var countryCode: String?
    var birthDate: String?
    var phone: String?
    var runSignUpUserID: String?
    var runSignUpOauthToken: String?
    var runSignUpOauthSecret: String?
    var profileImage: String?
    
    func dictionaryOfUser()->[String : String]{
        var data = [String: String]()
        data["firstName"] = firstName
        data["lastName"] = lastName
        data["gender"] = gender
        data["email"] = email
        data["street"] = street
        data["zipcode"] = zipcode
        data["birthDate"] = birthDate
        data["phone"] = phone
        data["runSignUpUserID"] = runSignUpUserID
        data["runSignUpOauthToken"] = runSignUpOauthToken
        data["runSignUpOauthSecret"] = runSignUpOauthSecret
        data["profileImage"] = profileImage
        
        return data
    }
}


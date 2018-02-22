//
//  Validator.swift
//  Kenroko VRC
//
//  Created by Michael Jones on 12/8/17.
//  Copyright © 2017 Kenroko. All rights reserved.
//

import Foundation

class Validator{
    
    //validates name field
    static func validateName(name: String)-> Bool {
        let noSpace = name.trimmingCharacters(in: [" "])
        print("name character count: \(name.count) - noSpace character count: \(noSpace.count)")
        
        return noSpace.count > 0
    }
    //validates email field
    static func validateEmail(email: String)-> Bool {
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = email as NSString
            let results = regex.matches(in: email, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0 {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
        
    }
    //validates password meets password requirements
    static func validatePassword(password: String) -> Bool {
        return password.count > 5
    }
    //confirms both passwords are equal
    static func validateSamePassoword(password: String, confirmPassword: String) -> Bool {
        return password == confirmPassword
    }
    
    
}

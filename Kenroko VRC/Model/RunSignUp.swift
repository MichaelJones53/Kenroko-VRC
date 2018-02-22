//
//  RunSignUp.swift
//  Kenroko VRC
//
//  Created by Michael Jones on 1/22/18.
//  Copyright © 2018 Kenroko. All rights reserved.
//

import Foundation
import OAuthSwift

class RunSignUp{
    static let RUNSIGNUPGETURL = "https://runsignup.com/rest/"
    static let REGISTERED_RACES = "\(RUNSIGNUPGETURL)user/registered-races"
    static let COUNTRIES = "\(RUNSIGNUPGETURL)countries"
    static let REGISTER_PAGE = "https://runsignup.com/CreateAccount?redirect=%2F%3FautoLogin%3DF"
    
    static let oauthKey = "463aa585973de64089c2d4c8674a3144828e7e89"
    static let oauthSecret = "c75e735698ba8441876df2e8f17e92e8f128cb58"
    
    static let callbackURL = "https://kenrokovrc-511cb.firebaseapp.com/register"
    
    static let oauthLoginURL = "https://runsignup.com/OAuth/Verify"
    static let requestTokenEndpointURL = "https://runsignup.com/oauth/requestToken.php"
    static let accessTokenEndpointURL = "https://runsignup.com/oauth/accessToken.php"
    
    let oauthswift = OAuth1Swift(
        consumerKey:    oauthKey,
        consumerSecret: oauthSecret,
        requestTokenUrl: requestTokenEndpointURL,
        authorizeUrl:    oauthLoginURL,
        accessTokenUrl:  accessTokenEndpointURL
    )
    
    
    
    
    
    func runSignUpGetCountries(address: String, completion: @escaping (String)->()){
        let session = openGETSession()
        let req = createGETURLRequest(address: RunSignUp.COUNTRIES)
        
        session.dataTask(with: req){data, response, error in
            
            if error != nil{
                print ("error: \(error!.localizedDescription)")
                completion("")
            }else{
                let results = String(data: data!, encoding: .utf8)!
                print("session entered: \(results)")
                completion(results)
            }
            }.resume()
    }
    
    
    
    
    
    func getRunSignUpUser(success: @escaping (String)->(), failure: @escaping (String)->()){
        
        _ = oauthswift.client.get("https://runsignup.com/rest/user/", success: { (results) in
            
            success(results.dataString()!)
            
        }) { (error) in
            
            failure(error.localizedDescription)
        }
    }
    
    
    
    
    func getKenrokoRaces(success: @escaping (String)->(), failure: @escaping (String)->()){
        
        let filter = ["start_date": "2017-01-01", "name":"Kenroko", "events": "T"]
        
        _ = oauthswift.client.get("https://runsignup.com/Rest/races/?", parameters: filter, success: { (results) in
            success(results.dataString()!)
        }) { (err) in
            failure(err.localizedDescription)
        }
        
    }
    
    func runSignUpGetRegisteredRaces(completion: @escaping (String)->()){
        
        _ = oauthswift.client.get(RunSignUp.REGISTERED_RACES, success: { (response) in
            //handle success
            completion(response.dataString()!)
            
        }) { (error) in
            //handle error
            print("ERROR in getRegisteredRaces")
            completion(error.localizedDescription)
            
        }
        
        
    }
    
    func runSignUpGetRaceResults(withRaceID raceID: Int, withEventID eventID: Int, success: @escaping (String)->(),  failure: @escaping (String)->()){
        
        let param = ["event_id": eventID]
        
        _ = oauthswift.client.get("https://runsignup.com/rest/race/\(raceID)/results/get-results", parameters: param, success: { (results) in
            success(results.dataString()!)
            
        }) { (error) in
            print("Failure")
            failure(error.localizedDescription)
            
        }
        
        
        
        
        
    }
    
    private func createGETURLRequest(address: String)-> URLRequest{
        var req = URLRequest(url: URL(string: address)!)
        req.httpMethod = "GET"
        return req
    }
    
    private func openGETSession()->URLSession{
        
        let session = URLSession.shared
        
        return session
    }
    
    func setCredentials(withToken token: String, withSecret secret: String){
        oauthswift.client.credential.oauthToken = token
        oauthswift.client.credential.oauthTokenSecret = secret
    }
    
    func authorize(completion: @escaping (OAuthSwiftCredential)->(), error: @escaping (String)->()){
        
        oauthswift.authorize(
            withCallbackURL: URL(string: RunSignUp.callbackURL)!,
            success: { credential, response, parameters in
                
                completion(credential)
                
                
        },
            failure: { err in
                print("ERROR")
                print(err.localizedDescription)
                print(err.description)
                error(err.localizedDescription)
                
        }
        )
    }
}

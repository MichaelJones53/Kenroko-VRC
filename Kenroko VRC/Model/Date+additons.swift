//
//  Date+additons.swift
//  Kenroko VRC
//
//  Created by Michael Jones on 12/22/17.
//  Copyright © 2017 Kenroko. All rights reserved.
//

import Foundation

extension Date{
    
    func getMonthName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        let strMonth = dateFormatter.string(from: self)
        return strMonth
    }
    
    
    
}

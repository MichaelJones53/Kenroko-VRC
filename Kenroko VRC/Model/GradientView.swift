//
//  GradientView.swift
//  Kenroko VRC
//
//  Created by Michael Jones on 10/21/17.
//  Copyright © 2017 Michael Jones. All rights reserved.
//

import Foundation
import UIKit

class GradientView{
    
    static func getGradientLayer()-> CAGradientLayer{
        let gradientLayer = CAGradientLayer()
        // teal color:      #C5E8EF UIColor(red:0.35, green:0.55, blue:0.78, alpha:1.0)
        // dark blue:       #588DC8 UIColor(red:0.35, green:0.55, blue:0.78, alpha:1.0)
        // yellow color:    #FAE99A UIColor(red:0.98, green:0.91, blue:0.60, alpha:1.0)
        
        let tealColor = UIColor(red:0.77, green:0.91, blue:0.94, alpha:1.0).cgColor
        let yellowColor = UIColor(red:0.98, green:0.91, blue:0.60, alpha:1.0).cgColor
        let  darkBlueColor = UIColor(red:0.35, green:0.55, blue:0.78, alpha:1.0).cgColor
        
        gradientLayer.colors = [yellowColor, tealColor, darkBlueColor]
        gradientLayer.locations=[0,0.6, 0.8]
        //        gradientLayer.startPoint = CGPoint(x: 0,y: 0);
        //        gradientLayer.endPoint = CGPoint(x: 0.3,y: 1);
        
        
        return gradientLayer
    }
    
    static func makeBackgroundGradient(vc: UIViewController){
        let gradientLayer = GradientView.getGradientLayer()
        gradientLayer.frame = vc.view.bounds
        vc.view.layer.insertSublayer(gradientLayer, at: 0)
    }
}

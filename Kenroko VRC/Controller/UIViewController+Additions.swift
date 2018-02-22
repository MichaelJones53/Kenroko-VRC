//
//  UIViewController+Additions.swift
//  Kenroko VRC
//
//  Created by Michael Jones on 12/10/17.
//  Copyright © 2017 Kenroko. All rights reserved.
//

import UIKit

extension UIViewController{
   
    func addMenuButton(title: String){
        let submitButton = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.plain, target: self, action: #selector(submitAction(_:)))
        self.navigationItem.rightBarButtonItem = submitButton
    }
    
    //set navigation styles
    func styleNavigation(title: String){
        self.navigationController?.navigationBar.isHidden = false;
        self.title = title
    }
    
    @objc func submitAction(_ sender:UIBarButtonItem!){}
    
    //adds images to left of textFields
    func addImageLeftTextField(toTextField: UITextField, withImage: String){
        let outerView = UIView(frame: CGRect(x: 0, y:0, width: toTextField.frame.height+5, height: toTextField.frame.height))
        let fieldImageFrame = CGRect(x: 5, y: 0, width: toTextField.frame.height, height: toTextField.frame.height)
        toTextField.leftViewMode = UITextFieldViewMode.always
        
        let imageView = UIImageView(frame: fieldImageFrame)
        
        let image = UIImage(named: withImage)
        
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        
        outerView.addSubview(imageView)
        toTextField.leftView = outerView
    }
    
    //adds images to left of textFields
    func addImageLeftTextField(toTextField: UITextField, withUIImage: UIImage){
        let outerView = UIView(frame: CGRect(x: 0, y:0, width: toTextField.frame.height+5, height: toTextField.frame.height))
        let fieldImageFrame = CGRect(x: 5, y: 0, width: toTextField.frame.height, height: toTextField.frame.height)
        toTextField.leftViewMode = UITextFieldViewMode.always
        
        let imageView = UIImageView(frame: fieldImageFrame)
        imageView.image = withUIImage
        imageView.contentMode = .scaleAspectFit
        
        outerView.addSubview(imageView)
        toTextField.leftView = outerView
    }
    
    func addKeyboardRelease(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func countryCodeAsEmoji(countryCode: String) -> Character {
        let base = UnicodeScalar("🇦").value - UnicodeScalar("A").value
        
        var string = ""
        countryCode.uppercased().unicodeScalars.forEach {
            if let scala = UnicodeScalar(base + $0.value) {
                string.append(String(describing: scala))
            }
        }
        
        return Character(string)
    }
}

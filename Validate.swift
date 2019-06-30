//
//  Validate.swift
//  AUTOBCM
//
//  Created by vishnu jangid on 08/02/18.
//  Copyright © 2018 brsoftech. All rights reserved.
//

import UIKit

extension String {
    
    
    //To check text field or String is blank or not
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }
    
    //Validate Email
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    
    //Validate Shopping Amount
    var isAmount: Bool {
        do {
            let regex = try NSRegularExpression(pattern: ".", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    
    //Validate Vintage
    var isVintage: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    
}

class Validate: NSObject {
    
    class func isValidMobileNumber(testString:String) -> Bool
    {
        let teststring=testString.trimmingCharacters(in: NSCharacterSet.whitespaces)
        if teststring.length < 6 || teststring.length > 10{
            return false
        }
        let mobileRegex = "^([0-9]*)$"
        
        let mobileTemp = NSPredicate(format:"SELF MATCHES %@", mobileRegex)
        return mobileTemp.evaluate(with: teststring)
    }
    
    class func isEntercharacter(testString:String) -> Bool {
        let emailRegEx = "([a-zA-Z]*)"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testString)
    }
}

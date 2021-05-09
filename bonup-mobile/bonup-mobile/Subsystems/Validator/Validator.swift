//
//  Validator.swift
//  bonup-mobile
//
//  Created by Yahor Bychkouski on 9.05.21.
//  Copyright © 2021 Bonup. All rights reserved.
//

import Foundation

protocol IValidator {
    
    func onlyLetters(_ string: String) -> Bool
    func onlySingleWord(_ string: String) -> Bool
    func onlyNumbers(_ string: String) -> Bool
    func isEmail(_ string: String) -> Bool
    func isWebSite(_ string: String) -> Bool
    func isPhoneNumber(_ string: String) -> Bool
}

final class Validator: IValidator {
    
    func onlyLetters(_ string: String) -> Bool {
        
        for chr in string {
            
            if !(chr >= "a" && chr <= "z") &&
               !(chr >= "A" && chr <= "Z") &&
               !(chr >= "а" && chr <= "я") &&
               !(chr >= "А" && chr <= "Я") &&
               chr != " " {
                
                return false
            }
        }
        
        return true
    }
    
    func onlySingleWord(_ string: String) -> Bool {
        
        return string.components(separatedBy: " ").count == 1
    }
    
    func onlyNumbers(_ string: String) -> Bool {
        
        for chr in string {
            
            if !(chr >= "0" && chr <= "9") {
                
                return false
            }
        }
        
        return true
    }
    
    func isEmail(_ string: String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        return self.validateRegEx(emailRegEx, string: string)
    }
    
    func isWebSite(_ string: String) -> Bool {
        
        let urlRegEx = "^(https?://)?(www\\.)?([-a-z0-9]{1,63}\\.)*?[a-z0-9][-a-z0-9]{0,61}[a-z0-9]\\.[a-z]{2,6}(/[-\\w@\\+\\.~#\\?&/=%]*)?$"
        
        return self.validateRegEx(urlRegEx, string: string)
    }
    
    func isPhoneNumber(_ string: String) -> Bool {
        
        let phoneRegEx = "^\\+375 \\((17|29|33|44)\\) [0-9]{3}-[0-9]{2}-[0-9]{2}$"
        
        return self.validateRegEx(phoneRegEx, string: string)
    }
    
    // MARK: - Private
    
    private func validateRegEx(_ regEx: String, string: String) -> Bool {
       
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        
        return pred.evaluate(with: string)
    }
}

//
//  String+RegEx.swift
//  ReelChat
//
//  Created by 정영민 on 2024/05/13.
//

import UIKit

extension String {
    func phoneNumberString(dash: String = "-") -> String {
        if self.count == 10 {
            let number = self.replacingOccurrences(of: "(\\d{3})(\\d{3})(\\d+)", with: "$1\(dash)$2\(dash)$3", options: .regularExpression, range: nil)
            return number
        }
        else if self.count == 11 {
            let number = self.replacingOccurrences(of: "(\\d{3})(\\d{4})(\\d+)", with: "$1\(dash)$2\(dash)$3", options: .regularExpression, range: nil)
            return number
        }

        return self
    }
}

/// Validations
extension String {
    private var emailRegEx: String {
        return "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    }
    
    func validate(regex: String) -> Bool {
        let predicate = NSPredicate(format:"SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    func validateEmail() -> Bool {
        return validate(regex: emailRegEx)
    }
}

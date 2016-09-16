//
//  Validator.swift
//  SendGrid
//
//  Created by Scott Kawai on 5/15/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import Foundation

/**
 
 The `Validator` enum provides quick ways to validate common input.
 
 */
enum Validator {
    
    // MARK: - Cases
    //=========================================================================
    
    /// Validates an email address.
    case email(String)
    
    /// Validates text to be used in the subscription tracking setting.
    case subscriptionTrackingText(String)
    
    /// Validates that a string does contain CLRF characters.
    case clrfValidator(String)
    
    /// A catch all custom validator where you can provide a string and a regex pattern.
    case other(input: String, pattern: String)
    
    
    // MARK: - Properties
    //=========================================================================
    
    /// The regular expression pattern used to validate the associated value.
    var pattern: String {
        switch self {
        case .email(_):
            return "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        case .subscriptionTrackingText(_):
            return "<% .*%>"
        case .clrfValidator(_):
            return "(;|,|\\s)"
        case .other(_, let str):
            return str
        }
    }
    
    /// The inputted value to validate.
    var input: String {
        switch self {
        case .email(let em):
            return em
        case .subscriptionTrackingText(let sub):
            return sub
        case .clrfValidator(let str):
            return str
        case .other(let str, _):
            return str
        }
    }
    
    /// A bool indicating if the associated value is valid or not.
    var valid: Bool {
        guard let regex = try? NSRegularExpression(pattern: self.pattern, options: [.caseInsensitive])
            else { return false }
        return regex.numberOfMatches(in: self.input, options: [], range: NSMakeRange(0, self.input.characters.count)) > 0
    }
    
}

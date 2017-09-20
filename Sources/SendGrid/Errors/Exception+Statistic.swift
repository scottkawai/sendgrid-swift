//
//  Exception+Statistic.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/20/17.
//

import Foundation

public extension Exception {
    
    public enum Statistic: Error, CustomStringConvertible {
        
        /// Thrown if the end date is before the start date.
        case invalidEndDate
        
        /// A description of the error.
        public var description: String {
            switch self {
            case .invalidEndDate:
                return "The end date cannot be any earlier in time than the start date."
            }
        }
        
    }
    
}

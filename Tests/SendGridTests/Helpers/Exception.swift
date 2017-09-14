//
//  Exception.swift
//  SendGridTests
//
//  Created by Scott Kawai on 9/14/17.
//

import Foundation

enum Exception: Error, CustomStringConvertible {
    case encodedDataIsNilString
    var description: String {
        switch self {
        case .encodedDataIsNilString:
            return "The encoded object could not be represented as a `String`."
        }
    }
}

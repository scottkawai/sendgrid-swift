//
//  DictionaryConvertible.swift
//  SendGrid
//
//  Created by Scott Kawai on 5/13/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import Foundation

/**
 
 The `DictionaryConvertible` protocol defines the properties a class or struct needs to implement in order to be represented as a dictionary. This is used to help generate the JSON payload that eventually gets sent to the SendGrid API.
 
 */
public protocol DictionaryConvertible {
    /// The dictionary representation of the object.
    var dictionaryValue: [AnyHashable: Any] { get }
}

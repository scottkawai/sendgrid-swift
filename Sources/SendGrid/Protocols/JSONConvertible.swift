//
//  JSONConvertible.swift
//  SendGrid
//
//  Created by Scott Kawai on 5/13/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import Foundation

/**
 
 The `JSONConvertible` protocol defines the properties needed for a class to provide a JSON representation of itself. This is used to generate the JSON sent to the SendGrid API.
 
 */
public protocol JSONConvertible: DictionaryConvertible {
    /// The JSON representation of the object.
    var jsonValue: String? { get }
}

public extension JSONConvertible {
    /// The default implementation of `jsonValue` converts the `dictionaryValue` into JSON.
    public var jsonValue: String? {
        return ParameterEncoding.jsonString(from: self.dictionaryValue)
    }
}

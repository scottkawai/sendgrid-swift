//
//  Validatable.swift
//  SendGrid
//
//  Created by Scott Kawai on 5/18/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import Foundation

/**
 
 The `Validatable` protocol defines the functions that a class or struct needs to implement in order to be used as an email property and validate their own values.
 
 */
public protocol Validatable {
    
    /**
     
     This method is implemented by all conforming classes to validate their own values. If everything is valid, the method does not need to return or do anything. If one or more values are invalid, an error should be thrown.
     
     */
    func validate() throws
    
}

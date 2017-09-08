//
//  Exception.swift
//  SendGrid
//
//  Created by Scott Kawai on 5/13/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import Foundation

/**
 
 The `Exception` struct contains all the errors that the SendGrid-Swift library can throw.
 
 */
public struct Exception {}

@available(*, unavailable, message: "'SGError' has been renamed to 'Exception'.")
public typealias SGError = Exception

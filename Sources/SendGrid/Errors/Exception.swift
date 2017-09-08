//
//  Exception.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/8/17.
//

import Foundation

/**
 
 The `Exception` struct contains all the errors that the SendGrid-Swift library can throw.
 
 */
public struct Exception {}

@available(*, unavailable, message: "'SGError' has been renamed to 'Exception'.")
public typealias SGError = Exception

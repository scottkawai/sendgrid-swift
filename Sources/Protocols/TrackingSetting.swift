//
//  TrackingSetting.swift
//  SendGrid
//
//  Created by Scott Kawai on 5/15/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import Foundation

/**
 
 The `TrackingSetting` protocol represents the properties needed for a class to represent a tracking setting.
 
 */
public protocol TrackingSetting: JSONConvertible {
    
    /// A bool indicating if the setting should be toggle on or off.
    var enable: Bool { get }
}
//
//  TrackingSetting.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/15/17.
//

import Foundation

/// The `TrackingSetting` protocol represents the properties needed for a class
/// to represent a tracking setting.
public protocol TrackingSetting: Encodable {
    
    /// A bool indicating if the setting should be toggle on or off.
    var enable: Bool { get }
    
}

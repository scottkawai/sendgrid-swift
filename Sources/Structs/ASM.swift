//
//  ASM.swift
//  SendGrid
//
//  Created by Scott Kawai on 5/17/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import Foundation

/**
 
 The `ASM` struct is used to specify an unsubscribe group to associate the email with.
 
 */
public struct ASM: JSONConvertible, Validatable {
    
    // MARK: - Properties
    //=========================================================================
    
    /// The ID of the unsubscribe group to use.
    public let id: Int
    
    
    /// A list of IDs that should be shown on the "Manage Subscription" page for this email.
    public let groupsToDisplay: [Int]?
    
    
    // MARK: - Computed Properties
    //=========================================================================
    
    /// The dictionary representation of the `ASM` struct.
    public var dictionaryValue: [NSObject : AnyObject] {
        var hash: [NSObject:AnyObject] = [
            "group_id": self.id
        ]
        if let groups = self.groupsToDisplay where groups.count > 0 {
            hash["groups_to_display"] = groups.map({ (i) -> NSNumber in
                return i
            })
        }
        return [
            "asm": hash
        ]
    }
    
    
    // MARK: - Initialization
    //=========================================================================
    
    /**
     
     Initializes the struct with a group ID and a list of group IDs to display on the manage subscription page for the email.
     
     - parameter groupID:           The ID of the unsubscribe group to use.
     - parameter groupsToDisplay:   An array of integers representing the IDs of other unsubscribe groups to display on the subscription page.
     
     */
    public init(groupID: Int, groupsToDisplay: [Int]? = nil) {
        self.id = groupID
        self.groupsToDisplay = groupsToDisplay
    }
    
    
    // MARK: - Methods
    //=========================================================================
    /**
     
     Validates that there are no more than 25 groups to display.
     
     */
    public func validate() throws {
        if let display = self.groupsToDisplay where display.count > Constants.UnsubscribeGroups.MaximumNumberOfDisplayGroups {
            throw Error.Mail.TooManyUnsubscribeGroups
        }
    }
}
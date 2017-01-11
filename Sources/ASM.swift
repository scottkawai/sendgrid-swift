//
//  ASM.swift
//  SendGrid
//
//  Created by Scott Kawai on 7/26/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import Foundation

/**
 
 The `ASM` class is used to specify an unsubscribe group to associate the email with.
 
 */
open class ASM: JSONConvertible, Validatable {
    
    // MARK: - Properties
    //=========================================================================
    
    /// The ID of the unsubscribe group to use.
    open let id: Int
    
    
    /// A list of IDs that should be shown on the "Manage Subscription" page for this email.
    open let groupsToDisplay: [Int]?
    
    
    // MARK: - Computed Properties
    //=========================================================================
    
    /// The dictionary representation of the `ASM` struct.
    open var dictionaryValue: [AnyHashable: Any] {
        var hash: [AnyHashable: Any] = [
            "group_id": self.id
        ]
        if let groups = self.groupsToDisplay, groups.count > 0 {
            hash["groups_to_display"] = groups
        }
        return hash
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
    open func validate() throws {
        if let display = self.groupsToDisplay {
            guard display.count <= Constants.UnsubscribeGroups.MaximumNumberOfDisplayGroups else {
                throw SGError.Mail.tooManyUnsubscribeGroups
            }
        }
    }
}

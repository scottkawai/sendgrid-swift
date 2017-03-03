//
//  Constants.swift
//  SendGrid
//
//  Created by Scott Kawai on 5/17/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import Foundation

/**
 
 A struct containing a set of constants used throughout the library.
 
 */
public struct Constants {
    
    /// The version number of the library.
    static let Version: String = "0.1.0"
 
    /// The upper limit to the number of personalizations allowed in an email.
    static let PersonalizationLimit: Int = 1000
    
    /// The upper limit to the number of recipients that can be in an email.
    static let RecipientLimit: Int = 1000
    
    /// The upper limit on how many substitutions are allowed.
    static let SubstitutionLimit: Int = 10000
    
    /// The maximum amount of seconds in the future an email can be scheduled for.
    static let ScheduleLimit: TimeInterval = (72 * 60 * 60)
    
    /**
     
     Constants for categories
     
     */
    struct Categories {
        
        /// The max number of categories allowed in an email.
        static let TotalLimit: Int = 10
        
        /// The max number of characters allowed in a category name.
        static let CharacterLimit: Int = 255
    }
    
    /**
     
     Constants for the subscription tracking setting.
     
     */
    public struct SubscriptionTracking {
        
        /// The default verbiage for the plain text unsubscribe footer.
        public static let DefaultPlainText = NSLocalizedString(
            "If you would like to unsubscribe and stop receiving these emails click here: <% %>.",
            comment: "Default subscription tracking text")
        
        /// The default verbiage for the HTML text unsubscribe footer.
        public static let DefaultHTMLText = NSLocalizedString(
            "<p>If you would like to unsubscribe and stop receiving these emails <% click here %>.</p>",
            comment: "Default subscription tracking HTML")
    }
    
    /**
     
     Constants for custom arguments.
     
     */
    public struct CustomArguments {
        
        /// The maximum number of bytes allowed for custom arguments in an email.
        public static let MaximumBytes: Int = 10000
    }
    
    /**
     
     Constants for ASM.
     
     */
    public struct UnsubscribeGroups {
        
        /// The maximum number of unsubscribe groups you can specify in the `groupsToDisplay` property.
        public static let MaximumNumberOfDisplayGroups: Int = 25
    }
    
}

//
//  SpamChecker.swift
//  SendGrid
//
//  Created by Scott Kawai on 5/17/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import Foundation

/**
 
 The `SpamChecker` mail setting allows you to test the content of your email for spam.
 
 */
open class SpamChecker: Setting, MailSetting, Validatable {
    
    // MARK: - Properties
    //=========================================================================
    
    /// The threshold used to determine if your content qualifies as spam on a scale from 1 to 10, with 10 being most strict, or most likely to be considered as spam.
    open let threshold: Int
    
    /// A webhook URL that you would like a copy of your email along with the spam report to be POSTed to.
    open let postURL: URL?
    
    
    // MARK: - Computed Properties
    //=========================================================================
    
    /// The dictionary representation of the setting.
    open override var dictionaryValue: [AnyHashable: Any] {
        var hash = super.dictionaryValue
        hash["threshold"] = self.threshold
        if let url = self.postURL {
            hash["post_to_url"] = url.absoluteString
        }
        return [
            "spam_check": hash
        ]
    }
    
    
    // MARK: - Initialization
    //=========================================================================
    /**
     
     Initializes the setting with a threshold and optional URL to POST spam reports to. If `threshold` is either below 1 or above 10, an error is thrown.
     
     - parameter enable:	A bool indicating if the setting should be on or off.
     - parameter threshold: An integer used to determine if your content qualifies as spam on a scale from 1 to 10, with 10 being most strict, or most likely to be considered as spam.
     - parameter url:       A webhook URL that you would like a copy of your email along with the spam report to be POSTed to.
     
     - returns: Return
     
     */
    public init(enable: Bool, threshold: Int, url: URL? = nil) {
        self.threshold = threshold
        self.postURL = url
        super.init(enable: enable)
    }
    
    
    // MARK: - Methods
    //=========================================================================
    /**
     
     Validates that the threshold is within the correct range.
     
     */
    open func validate() throws {
        guard (1...10).contains(self.threshold) else { throw SGError.Mail.thresholdOutOfRange(threshold) }
    }
    
}

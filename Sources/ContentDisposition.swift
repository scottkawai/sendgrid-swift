//
//  ContentDisposition.swift
//  SendGrid
//
//  Created by Scott Kawai on 5/17/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import Foundation

/**
 
 The `ContentDisposition` represents the various content-dispositions an attachment can have.
 
 */
public enum ContentDisposition: String {
    
    // MARK: - Cases
    //=========================================================================
    
    /// The "inline" disposition, which shows the attachment inline with text.
    case inline
    
    /// The "attachment" disposition, which shows the attachment below the text.
    case attachment
    
}

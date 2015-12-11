//
//  Attachment.swift
//  SendGrid
//
//  Created by Scott Kawai on 12/11/15.
//  Copyright © 2015 SendGrid. All rights reserved.
//

import Foundation

public extension SendGrid {
    public class Attachment {
        let filename: String
        let content: NSData
        let contentType: String
        let cid: String?
        
        init(filename name: String, content data: NSData, contentType type: String, cid id: String? = nil) {
            self.filename = name
            self.content = data
            self.contentType = type
            self.cid = id
        }
    }
}
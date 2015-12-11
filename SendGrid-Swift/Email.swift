//
//  Email.swift
//  SendGrid
//
//  Created by Scott Kawai on 10/17/15.
//  Copyright © 2015 SendGrid. All rights reserved.
//

import Foundation

public extension SendGrid {
    public class Email {
        
        // MARK: PROPERTIES
        //=========================================================================
        
        public var to: [String]?
        public var toname: [String]?
        public var subject: String?
        public var from: String?
        public var fromname: String?
        public var text: String?
        public var html: String?
        public var headers: [String:String]?
        public var cc: [String]?
        public var bcc: [String]?
        public var replyto: String?
        public var attachments: [SendGrid.Attachment]?
        
        public let smtpapi = SmtpApi()
        public var hasRecipientsInSmtpApi = true
        
        // MARK: INITIALIZATION
        //=========================================================================
        
        public init() {}
        
        // MARK: FUNCTIONS
        //=========================================================================
        
        public func addTo(address: String, name: String? = nil) throws {
            var names: [String]?
            if let n = name {
                names = [n]
            }
            try self.addTos([address], names: names)
        }
        
        public func addTos(addresses: [String], names: [String]? = nil) throws {
            if self.hasRecipientsInSmtpApi {
                try self.smtpapi.addTos(addresses, names: names)
            } else {
                if self.to == nil {
                    self.to = []
                }
                
                if let toNames = names {
                    if self.toname == nil {
                        self.toname = []
                    }
                    if addresses.count == toNames.count {
                        self.toname! += toNames
                    } else {
                        throw SmtpApiErrors.NumberOfRecipientNamesMismatch
                    }
                } else if self.toname != nil {
                    self.toname?.append("")
                }
                
                self.to! += addresses
            }
        }
        
        public func setTos(addresses: [String], names: [String]? = nil) throws {
            if self.hasRecipientsInSmtpApi {
                try self.smtpapi.setTos(addresses, names: names)
            } else {
                self.to = nil
                self.toname = nil
                try self.addTos(addresses, names: names)
            }
        }
        
        public func setSubject(subject: String) {
            self.subject = subject
        }
        
        public func setFrom(address: String, name: String? = nil) {
            self.from = address
            self.fromname = name
        }
        
        public func setReplyTo(address: String) {
            self.replyto = address
        }
        
        public func addCC(address: String) {
            self.addCCs([address])
        }
        
        public func addCCs(addresses: [String]) {
            if self.cc != nil {
                self.cc! += addresses
            } else {
                self.cc = addresses
            }
        }
        
        public func setCCs(addresses: [String]) {
            self.cc = nil
            self.addCCs(addresses)
        }
        
        public func addBCC(address: String) throws {
            try self.addBCCs([address])
        }
        
        public func addBCCs(addresses: [String]) throws {
            if self.hasRecipientsInSmtpApi {
                throw SendGridErrors.BccAddedWithSmtpApi
            }
            if self.bcc != nil {
                self.bcc! += addresses
            } else {
                self.bcc = addresses
            }
        }
        
        public func setBCCs(addresses: [String]) throws {
            self.bcc = nil
            try self.addBCCs(addresses)
        }
        
        public func setTextBody(text: String) {
            self.text = text
        }
        
        public func setHtmlBody(html: String) {
            self.html = html
        }
        
        public func setBody(text: String, html: String) {
            self.setTextBody(text)
            self.setHtmlBody(html)
        }
        
        public func addHeader(key: String, value: String) {
            self.addHeaders([key: value])
        }
        
        public func addHeaders(keyValuePairs: [String:String]) {
            if self.headers == nil {
                self.headers = keyValuePairs
            } else {
                for (key, value) in keyValuePairs {
                    self.headers![key] = value
                }
            }
        }
        
        public func setHeaders(keyValuePairs: [String:String]) {
            self.headers = nil
            self.addHeaders(keyValuePairs)
        }
        
        public func addAttachment(filename: String, data: NSData, contentType type: String, cid: String? = nil) {
            if self.attachments == nil {
                self.attachments = []
            }
            
            self.attachments?.append(SendGrid.Attachment(filename: filename, content: data, contentType: type, cid: cid))
        }
        
        // MARK: SMTPAPI CONVENIENCE METHODS
        //=========================================================================
        
        public func addSubstitution(key: String, values: [String]) {
            self.smtpapi.addSubstitution(key, values: values)
        }
        
        public func addSection(key: String, value: String) {
            self.smtpapi.addSection(key, value: value)
        }
        
        public func addUniqueArgument(key: String, value: String) {
            self.smtpapi.addUniqueArgument(key, value: value)
        }
        
        public func addCategory(category: String) throws {
            try self.addCategories([category])
        }
        
        public func addCategories(categories: [String]) throws {
            try self.smtpapi.addCategories(categories)
        }
        
        public func addFilter(filter: SendGridFilter, setting: String, value: Any) throws {
            try self.smtpapi.addFilter(filter, setting: setting, value: value)
        }
        
        public func setSendAt(date: NSDate) throws {
            try self.smtpapi.setSendAt(date)
        }
        
        public func setSendEachAt(dates: [NSDate]) throws {
            try self.smtpapi.setSendEachAt(dates)
        }
        
        public func setAsmGroup(id: Int) {
            self.smtpapi.setAsmGroup(id)
        }
        
        public func setIpPool(pool: String) {
            self.smtpapi.setIpPool(pool)
        }
    }

}
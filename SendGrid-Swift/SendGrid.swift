//
//  SendGrid.swift
//  SendGrid-Swift
//
//  Created by Scott Kawai on 6/18/14.
//  Copyright (c) 2014 SendGrid. All rights reserved.
//

import Foundation

class SendGrid {
    
    // MARK: VERSION
    //=========================================================================
    class var version: String {
        return "0.0.1"
    }
    
    // MARK: PROPERTIES
    //=========================================================================
    
    let username: String
    let password: String
    
    var to: [String]?
    var toname: [String]?
    var subject: String?
    var from: String?
    var fromname: String?
    var text: String?
    var html: String?
    var headers = []
    var cc: [String]?
    var bcc: [String]?
    var replyto: String?
    
    let smtpapi = SmtpApi()
    var hasRecipientsInSmtpApi = true
    
    
    // MARK: INITIALIZATION
    //=========================================================================
    
    init(username: String, password: String) {
        self.username = username;
        self.password = password;
    }
    
    
    // MARK: FUNCTIONS
    //=========================================================================
    
    func addTo(address: String, name: String?) {
        var names: [String]?
        if let n = name {
            names = [n]
        }
        self.addTos([address], names: names)
    }
    
    func addTos(addresses: [String], names: [String]?) {
        if self.hasRecipientsInSmtpApi {
            self.smtpapi.addTos(addresses, names: names)
        } else {
            if self.to == nil {
                self.to = []
            }
            
            if let toNames = names {
                if self.toname == nil {
                    self.toname = []
                }
                if countElements(addresses) == countElements(toNames) {
                    self.toname! += toNames
                } else {
                    println("[**ERROR**] SendGrid addTos: The number of email addresses provided didn't match the number of names provided.")
                    return
                }
            }
            
            self.to! += addresses
        }
    }
    
    func setTos(addresses: [String], names: [String]?) {
        if self.hasRecipientsInSmtpApi {
            self.smtpapi.setTos(addresses, names: names)
        } else {
            self.to = nil
            self.toname = nil
            self.addTos(addresses, names: names)
        }
    }
    
    func setSubject(subject: String) {
        self.subject = subject
    }
    
    func setFrom(address: String, name: String?) {
        self.from = address
        self.fromname = name
    }
    
    func setReplyTo(address: String) {
        self.replyto = address
    }
    
    func addCC(address: String) {
        self.addCCs([address])
    }
    
    func addCCs(addresses: [String]) {
        if self.cc != nil {
            self.cc! += addresses
        } else {
            self.cc = addresses
        }
    }
    
    func setCCs(addresses: [String]) {
        self.cc = nil
        self.addCCs(addresses)
    }
    
    func addBCC(address: String) {
        self.addBCCs([address])
    }
    
    func addBCCs(addresses: [String]) {
        if self.hasRecipientsInSmtpApi {
            Logger.warn("The BCC option will not work when specifying recipients in the X-SMTPAPI header. Set the `hasRecipientsInSmtpApi` to false before adding BCC addresses so that the 'To' addresses get added to the normal 'To' header instead of the X-SMTPAPI header.")
        }
        if self.bcc != nil {
            self.bcc! += addresses
        } else {
            self.bcc = addresses
        }
    }
    
    func setBCCs(addresses: [String]) {
        self.bcc = nil
        self.addBCCs(addresses)
    }
    
    func setTextBody(text: String) {
        self.text = text
    }
    
    func setHtmlBody(html: String) {
        self.html = html
    }
    
    func setBody(text: String, html: String) {
        self.setTextBody(text)
        self.setHtmlBody(html)
    }
    
    func send(completionHandler: ((NSURLResponse!, NSData!, NSError!) -> Void)?) {
        let url = NSURL(string: "https://api.sendgrid.com/api/mail.send.json")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        
        // BODY
        var params = [String:AnyObject]()
        if let apiUser = self.username.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
            params["api_user"] = apiUser
        }
        
        if let apiKey = self.password.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
            params["api_key"] = apiKey
        }
        
        var addToParamsIfPresent = { (key: String, param: AnyObject?) -> Bool in
            if let p: AnyObject = param {
                params[key] = p
                return true
            }
            return false
        }
        
        if !addToParamsIfPresent("from", self.from) {
            Logger.error("SendGrid send: Could not send message due to required `from` parameter missing.")
            return
        }
        
        addToParamsIfPresent("fromname", self.fromname)
        
        if self.hasRecipientsInSmtpApi && self.smtpapi.to != nil && countElements(self.smtpapi.to!) > 0 {
            params["to"] = self.from!
        } else if !self.hasRecipientsInSmtpApi && self.to != nil && countElements(self.to!) > 0 {
            params["to"] = self.to!
        } else {
            Logger.error("SendGrid send: Could not send message as no recipients were specified.")
            return
        }
        
        addToParamsIfPresent("toname", self.toname)
        
        if !addToParamsIfPresent("subject", subject) {
            Logger.error("SendGrid send: Could not send message - a subject is required.")
            return
        }
        
        addToParamsIfPresent("text", self.text)
        addToParamsIfPresent("html", self.html)
        addToParamsIfPresent("cc", self.cc)
        addToParamsIfPresent("bcc", self.bcc)
        addToParamsIfPresent("replyto", self.replyto)
        
        var body = ""
        for (paramName, paramValue) in params {
            if let arr = paramValue as? [String] {
                for value in arr {
                    if let encoded = value.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
                        if countElements(body) > 0 { body += "&" }
                        body += paramName + "[]=" + encoded
                    }
                }
            } else {
                if let encoded = paramValue.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
                    if countElements(body) > 0 { body += "&" }
                    body += paramName + "=" + encoded
                }
            }
        }
        
        // SMTPAPI
        if self.smtpapi.hasSmtpApi {
            body += "&x-smtpapi=" + self.smtpapi.jsonValue.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        }
        
        println(body)
        
        request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        let queue:NSOperationQueue = NSOperationQueue()
//        NSURLConnection.sendAsynchronousRequest(request, queue: queue) { (response, data, error) -> Void in
//            if let handler = completionHandler {
//                handler(response, data, error)
//            }
//        }
    }
}
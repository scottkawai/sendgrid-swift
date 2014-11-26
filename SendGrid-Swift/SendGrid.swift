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
    
    // MARK: INITIALIZATION
    //=========================================================================
    
    init(username: String, password: String) {
        self.username = username;
        self.password = password;
    }
    
    // MARK: FUNCTIONS
    //=========================================================================
    
    func send(email: SendGrid.Email, completionHandler: ((NSURLResponse!, NSData!, NSError!) -> Void)?) {
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
        
        if !addToParamsIfPresent("from", email.from) {
            Logger.error("SendGrid send: Could not send message due to required `from` parameter missing.")
            return
        }
        
        addToParamsIfPresent("fromname", email.fromname)
        
        if email.hasRecipientsInSmtpApi && email.smtpapi.to != nil && countElements(email.smtpapi.to!) > 0 {
            params["to"] = email.from!
        } else if !email.hasRecipientsInSmtpApi && email.to != nil && countElements(email.to!) > 0 {
            params["to"] = email.to!
        } else {
            Logger.error("SendGrid send: Could not send message as no recipients were specified.")
            return
        }
        
        addToParamsIfPresent("toname", email.toname)
        
        if !addToParamsIfPresent("subject", email.subject) {
            Logger.error("SendGrid send: Could not send message - a subject is required.")
            return
        }
        
        addToParamsIfPresent("text", email.text)
        addToParamsIfPresent("html", email.html)
        addToParamsIfPresent("cc", email.cc)
        addToParamsIfPresent("bcc", email.bcc)
        addToParamsIfPresent("replyto", email.replyto)
        addToParamsIfPresent("headers", email.headers)
        
        var body = NSMutableData()
        let boundary = "0xKhTmLbOuNdArY"
        var contentType = "multipart/form-data; boundary=\(boundary)"
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        request.addValue("sendgrid/\(SendGrid.version);swift", forHTTPHeaderField: "User-Agent")
        
        var addBoundary = { () -> Void in
            var b = "--\(boundary)\r\n"
            if let data = b.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                body.appendData(data)
            }
        }
        
        var addDisposition: ((param: String, filename: String?) -> Void) = { (param, filename) -> Void in
            var d = "Content-Disposition: form-data; name=\"\(param)\""
            if let f = filename {
                d += "; filename=\"\(filename)\""
            }
            d += "\r\n\r\n"
            if let data = d.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                body.appendData(data)
            }
        }
        
        var addParamValue: ((value: String) -> Void) = { (value) -> Void in
            var v = "\(value)\r\n"
            if let data = v.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                body.appendData(data)
            }
        }
        
        for (paramName, paramValue) in params {
            if let arr = paramValue as? [String] {
                for value in arr {
                    addBoundary()
                    addDisposition(param: "\(paramName)[]", filename: nil)
                    addParamValue(value: value)
                }
            } else {
                addBoundary()
                addDisposition(param: paramName, filename: nil)
                if paramName == "headers" {
                    var error: NSError?
                    var data = NSJSONSerialization.dataWithJSONObject(paramValue, options: nil, error: &error)
                    if let err = error {
                        Logger.error("Error converting headers to JSON - \(err.localizedDescription)")
                    } else if let d = data {
                        if let json = NSString(data: d, encoding: NSUTF8StringEncoding) {
                            addParamValue(value: json)
                        }
                    }
                } else if let value = paramValue as? String {
                    addParamValue(value: value)
                }
            }
        }
        
        if email.smtpapi.hasSmtpApi {
            addBoundary()
            addDisposition(param: "x-smtpapi", filename: nil)
            addParamValue(value: email.smtpapi.jsonValue)
        }
        
        if let cids = email.content {
            for (filename, id) in cids {
                addBoundary()
                addDisposition(param: "content[\(filename)]", filename: nil)
                addParamValue(value: id)
            }
        }
        
        if let files = email.attachments {
            for (file, data) in files {
                addBoundary()
                addDisposition(param: "files[\(file)]", filename: file)
                if let d = "Content-Type: application/octet-stream\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                   // body.appendData(d)
                }
                body.appendData(data)
            }
        }
        
        if let data = "--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            body.appendData(data)
        }
        
        //println(NSString(data: body, encoding: NSUTF8StringEncoding)!)
        
        request.HTTPBody = body
        let queue:NSOperationQueue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue: queue) { (response, data, error) -> Void in
            if let handler = completionHandler {
                handler(response, data, error)
            }
        }
    }
    
    
    class Email {
        
        // MARK: PROPERTIES
        //=========================================================================
        
        var to: [String]?
        var toname: [String]?
        var subject: String?
        var from: String?
        var fromname: String?
        var text: String?
        var html: String?
        var headers: [String:String]?
        var cc: [String]?
        var bcc: [String]?
        var replyto: String?
        var attachments: [String:NSData]?
        var content: [String:String]?
        
        let smtpapi = SmtpApi()
        var hasRecipientsInSmtpApi = true
        
        // MARK: INITIALIZATION
        //=========================================================================
        
        init() {}
        
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
                        Logger.error("SendGrid addTos: The number of email addresses provided didn't match the number of names provided.")
                        return
                    }
                } else if self.toname != nil {
                    self.toname?.append("")
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
        
        func addHeader(key: String, value: String) {
            self.addHeaders([key: value])
        }
        
        func addHeaders(keyValuePairs: [String:String]) {
            if self.headers == nil {
                self.headers = keyValuePairs
            } else {
                for (key, value) in keyValuePairs {
                    self.headers![key] = value
                }
            }
        }
        
        func setHeaders(keyValuePairs: [String:String]) {
            self.headers = nil
            self.addHeaders(keyValuePairs)
        }
        
        func addAttachment(filename: String, data: NSData, cid: String?) {
            if self.attachments == nil {
                self.attachments = [filename: data]
            } else {
                self.attachments![filename] = data
            }
            
            if let c = cid {
                if self.content == nil {
                    self.content = [filename: c]
                } else {
                    self.content![filename] = c
                }
            }
        }
        
        // MARK: SMTPAPI CONVENIENCE METHODS
        //=========================================================================
        
        func addSubstitution(key: String, values: [String]) {
            self.smtpapi.addSubstitution(key, values: values)
        }
        
        func addSection(key: String, value: String) {
            self.smtpapi.addSection(key, value: value)
        }
        
        func addUniqueArgument(key: String, value: String) {
            self.smtpapi.addUniqueArgument(key, value: value)
        }
        
        func addCategory(category: String) {
            self.addCategories([category])
        }
        
        func addCategories(categories: [String]) {
            self.smtpapi.addCategories(categories)
        }
        
        func addFilter(filter: SendGridFilter, setting: String, value: Any) {
            self.smtpapi.addFilter(filter, setting: setting, value: value)
        }
        
        func setSendAt(date: NSDate) {
            self.smtpapi.setSendAt(date)
        }
        
        func setSendEachAt(dates: [NSDate]) {
            self.smtpapi.setSendEachAt(dates)
        }
        
        func setAsmGroup(id: Int) {
            self.smtpapi.setAsmGroup(id)
        }
        
        func setIpPool(pool: String) {
            self.smtpapi.setIpPool(pool)
        }
    }
}
//
//  SendGrid.swift
//  SendGrid-Swift
//
//  Created by Scott Kawai on 6/18/14.
//  Copyright (c) 2014 SendGrid. All rights reserved.
//

import Foundation

public class SendGrid {
    
    // MARK: VERSION
    //=========================================================================
    class var version: String {
        return "0.0.2"
    }
    
    // MARK: PROPERTIES
    //=========================================================================
    
    let authorization: SendGridAuth
    
    // MARK: INITIALIZATION
    //=========================================================================
    
    public init(username: String, password: String) {
        self.authorization = SendGridAuth.Credentials(username: username, password: password)
    }
    
    public init(apiKey: String) {
        self.authorization = SendGridAuth.ApiKey(apiKey)
    }
    
    // MARK: FUNCTIONS
    //=========================================================================
    
    public func send(email: SendGrid.Email, completionHandler: ((NSURLResponse?, NSData?, NSError?) -> Void)?) throws {
        let url = NSURL(string: "https://api.sendgrid.com/api/mail.send.json")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        
        // BODY
        var params = [String:AnyObject]()
        let charactersToEscape = "!*'();:@&=+$,/?%#[]\" "
        let allowedCharacters = NSCharacterSet(charactersInString: charactersToEscape).invertedSet
        
        switch self.authorization {
        case .Credentials(let un, let pw):
            if let apiUser = un.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacters) {
                params["api_user"] = apiUser
            }
            
            if let apiKey = pw.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacters) {
                params["api_key"] = apiKey
            }
        case .ApiKey(let apiKey):
            request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        }
        
        let addToParamsIfPresent = { (key: String, param: AnyObject?) -> Bool in
            if let p: AnyObject = param {
                params[key] = p
                return true
            }
            return false
        }
        
        if !addToParamsIfPresent("from", email.from) {
            throw SendGridErrors.MissingFromAddress
        }
        
        addToParamsIfPresent("fromname", email.fromname)
        
        if email.hasRecipientsInSmtpApi && email.smtpapi.to != nil && (email.smtpapi.to!).count > 0 {
            params["to"] = email.from!
        } else if !email.hasRecipientsInSmtpApi && email.to != nil && (email.to!).count > 0 {
            params["to"] = email.to!
        } else {
            throw SendGridErrors.MissingRecipients
        }
        
        addToParamsIfPresent("toname", email.toname)
        
        if !addToParamsIfPresent("subject", email.subject) {
            throw SendGridErrors.MissingSubject
        }
        
        addToParamsIfPresent("text", email.text)
        addToParamsIfPresent("html", email.html)
        addToParamsIfPresent("cc", email.cc)
        addToParamsIfPresent("bcc", email.bcc)
        addToParamsIfPresent("replyto", email.replyto)
        addToParamsIfPresent("headers", email.headers)
        
        let body = NSMutableData()
        let boundary = "0xKhTmLbOuNdArY"
        let contentType = "multipart/form-data; boundary=\(boundary)"
        request.addValue(contentType, forHTTPHeaderField: "Content-Type")
        request.addValue("sendgrid/\(SendGrid.version);swift", forHTTPHeaderField: "User-Agent")
        
        let addBoundary = { () -> Void in
            let b = "--\(boundary)\r\n"
            if let data = b.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                body.appendData(data)
            }
        }
        
        let addDisposition: ((param: String, filename: String?) -> Void) = { (param, filename) -> Void in
            var d = "Content-Disposition: form-data; name=\"\(param)\""
            if let f = filename {
                d += "; filename=\"\(f)\""
            }
            d += "\r\n\r\n"
            if let data = d.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                body.appendData(data)
            }
        }
        
        let addParamValue: ((value: String) -> Void) = { (value) -> Void in
            let v = "\(value)\r\n"
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
                    let data = try NSJSONSerialization.dataWithJSONObject(paramValue, options: [])
                    if let json = NSString(data: data, encoding: NSUTF8StringEncoding) {
                        addParamValue(value: json as String)
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
                //                if let d = "Content-Type: application/octet-stream\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                // body.appendData(d)
                //                }
                body.appendData(data)
            }
        }
        
        if let data = "--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            body.appendData(data)
        }
        
        request.HTTPBody = body
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if let handler = completionHandler {
                handler(response, data, error)
            }
        }
        task.resume()
    }
    
}
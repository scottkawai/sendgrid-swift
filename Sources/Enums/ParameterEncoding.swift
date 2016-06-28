//
//  ParameterEncoding.swift
//  SendGrid
//
//  Created by Scott Kawai on 6/10/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import Foundation

/**
 
 The `ParameterEncoding` enum is used to encode values into their respective Content-Type's formatting.
 
 */
enum ParameterEncoding {
    // MARK: - Cases
    //=========================================================================
    /// Encodes `AnyObject` into "application/x-www-form-urlencoded".
    case FormUrlEncoded(AnyObject)
    
    /// Encodes `AnyObject` into minified JSON.
    case JSON(AnyObject)
    
    /// Encodes `AnyObject` into pretty print JSON.
    case PrettyJSON(AnyObject)
    
    // MARK: - Properties
    //=========================================================================
    /// The data representation of the encoded value.
    var data: NSData? {
        switch self {
        case .JSON(let params):
            var data: NSData?
            if NSJSONSerialization.isValidJSONObject(params) {
                data = try? NSJSONSerialization.dataWithJSONObject(params, options: [])
            }
            return data
        case .PrettyJSON(let params):
            var data: NSData?
            if NSJSONSerialization.isValidJSONObject(params) {
                data = try? NSJSONSerialization.dataWithJSONObject(params, options: [NSJSONWritingOptions.PrettyPrinted])
            }
            return data
        case .FormUrlEncoded(let params):
            guard let hash = params as? [NSObject:AnyObject] else { return nil }
            let components = NSURLComponents()
            components.queryItems = hash.map({ (key, value) -> NSURLQueryItem in
                return NSURLQueryItem(name: "\(key)", value: "\(value)")
            })
            return components.query?.dataUsingEncoding(NSUTF8StringEncoding)
        }
    }
    
    /// The String representation of the encoded value.
    var stringValue: String? {
        guard let d = self.data,
            str = NSString(data: d, encoding: NSUTF8StringEncoding) as? String
            else
        {
            return nil
        }
        return str
    }
}
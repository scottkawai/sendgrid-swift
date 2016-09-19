//
//  ParameterEncoding.swift
//  SendGrid
//
//  Created by Scott Kawai on 6/10/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import Foundation

/**
 
 The `ParameterEncoding` struct is used to encode values into their respective Content-Type's formatting.
 
 */
struct ParameterEncoding {
    
    /// Encodes `Any` into "application/x-www-form-urlencoded" data.
    static func formUrlEncodedData(from params: Any) -> Data? {
        return self.formUrlEncodedString(from: params)?.data(using: String.Encoding.utf8)
    }
    
    /// Encodes `Any` into a "application/x-www-form-urlencoded" string.
    static func formUrlEncodedString(from params: Any) -> String? {
        guard let hash = params as? [AnyHashable: Any] else { return nil }
        var components = URLComponents()
        components.queryItems = hash.map { (key, value) -> URLQueryItem in
            return URLQueryItem(name: "\(key)", value: "\(value)")
        }
        return components.query
    }
    
    /// Encodes `Any` into JSON data.
    static func jsonData(from params: [AnyHashable:Any], prettyPrint: Bool = false) -> Data? {
        guard JSONSerialization.isValidJSONObject(params) else { return nil }
        let options: JSONSerialization.WritingOptions = prettyPrint ? [.prettyPrinted] : []
        return try? JSONSerialization.data(withJSONObject: params, options: options)
    }
    
    /// Encodes `Any` into a JSON string.
    static func jsonString(from params: [AnyHashable:Any], prettyPrint: Bool = false) -> String? {
        guard let d = self.jsonData(from: params, prettyPrint: prettyPrint) else { return nil }
        return String(data: d, encoding: String.Encoding.utf8)
    }
}

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
    case formUrlEncoded(Any)
    
    /// Encodes `AnyObject` into minified JSON.
    case json(Any)
    
    /// Encodes `AnyObject` into pretty print JSON.
    case prettyJSON(Any)
    
    // MARK: - Properties
    //=========================================================================
    /// The data representation of the encoded value.
    var data: Data? {
        switch self {
        case .json(let params):
            var data: Data?
            if JSONSerialization.isValidJSONObject(params) {
                data = try? JSONSerialization.data(withJSONObject: params, options: [])
            }
            return data
        case .prettyJSON(let params):
            var data: Data?
            if JSONSerialization.isValidJSONObject(params) {
                data = try? JSONSerialization.data(withJSONObject: params, options: [JSONSerialization.WritingOptions.prettyPrinted])
            }
            return data
        case .formUrlEncoded(let params):
            guard let hash = params as? [AnyHashable: Any] else { return nil }
            var components = URLComponents()
            components.queryItems = hash.map({ (key, value) -> URLQueryItem in
                return URLQueryItem(name: "\(key)", value: "\(value)")
            })
            return components.query?.data(using: String.Encoding.utf8)
        }
    }
    
    /// The String representation of the encoded value.
    var stringValue: String? {
        guard let d = self.data,
            let str = NSString(data: d, encoding: String.Encoding.utf8.rawValue) as? String
            else
        {
            return nil
        }
        return str
    }
}

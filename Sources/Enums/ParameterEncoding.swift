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
            var entries: [String] = []
            
            func urlEncodeString(str: String) -> String {
                let charactersToEscape = "!*'();:@&=+$,/?%#[]\" "
                let allowedCharacters = NSCharacterSet(charactersInString: charactersToEscape).invertedSet
                
                if let str = str.stringByAddingPercentEncodingWithAllowedCharacters(allowedCharacters) where str.characters.count > 0 {
                    do {
                        let regex = try NSRegularExpression(pattern: "&", options: NSRegularExpressionOptions.CaseInsensitive)
                        return regex.stringByReplacingMatchesInString(str, options: [], range: NSMakeRange(0, (str.characters.count - 1)), withTemplate: "%26")
                    } catch {
                        NSLog("Error making string replacements in urlEncodedParameter.")
                    }
                }
                return ""
            }
            
            func handleParameter(parameter: AnyObject, forKey key: String?) -> Bool {
                var succeeded = true
                if let dict = parameter as? [NSObject:AnyObject] {
                    for (name, value) in dict {
                        if let n = name as? String {
                            let rootKey = (key == nil) ? n : "\(key!)[\(n)]"
                            succeeded = succeeded && handleParameter(value, forKey: rootKey)
                        } else {
                            succeeded = false
                            break
                        }
                    }
                } else if let name = key {
                    if let str = parameter as? String {
                        entries.append(name + "=" + urlEncodeString(str))
                    } else if let num = parameter as? NSNumber {
                        entries.append(name + "=" + urlEncodeString(num.stringValue))
                    } else if let arr = parameter as? [AnyObject] {
                        for param in arr {
                            succeeded = succeeded && handleParameter(param, forKey: "\(name)[]")
                        }
                    } else {
                        succeeded = false
                    }
                } else {
                    succeeded = false
                }
                return succeeded
            }
            if !handleParameter(params, forKey: nil) { return nil }
            return entries.joinWithSeparator("&").dataUsingEncoding(NSUTF8StringEncoding)
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
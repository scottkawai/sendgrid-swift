//
//  SGError+Mail.swift
//  SendGrid
//
//  Created by Scott Kawai on 6/9/16.
//  Copyright © 2016 Scott Kawai. All rights reserved.
//

import Foundation

public extension SGError {
    
    /**
     
     The `Mail` enum contains all the errors thrown for the mail send API.
     
     */
    public enum Mail: Error, CustomStringConvertible {
        
        // MARK: - Cases
        //=========================================================================
        
        /// The error thrown when an email address was expected, but received a String that isn't RFC 5322 compliant.
        case malformedEmailAddress(String)
        
        /// The error thrown when an email is scheduled further than 72 hours out.
        case invalidScheduleDate
        
        /// The error thrown if the subscription tracking setting is configured with text that doesn't contain a `<% %>` tag.
        case missingSubscriptionTrackingTag
        
        /// The error thrown if a personalization doesn't have at least 1 recipient.
        case missingRecipients
        
        /// The error thrown when the SpamChecker setting is provided a threshold outside the 1-10 range.
        case thresholdOutOfRange(Int)
        
        /// The error thrown when more than 25 unsubscribe groups are provided in the `ASM` struct.
        case tooManyUnsubscribeGroups
        
        /// The error thrown if the number of personalizations in an email is less than 1 or more than 100.
        case invalidNumberOfPersonalizations
        
        /// The error thrown if an email doesn't contain any content.
        case missingContent
        
        /// The error thrown if a `Content` instance has an empty string value.
        case contentHasEmptyString
        
        /// Thrown if the array of `Content` instances used in an `Email` instances is in an incorrect order.
        case invalidContentOrder
        
        /// Thrown when an email contains too many recipients across all the `to`, `cc`, and `bcc` properties of the personalizations.
        case tooManyRecipients
        
        /// Thrown if an email does not contain a subject line.
        case missingSubject
        
        /// Thrown if a reserved header was specified in the custom headers section.
        case headerNotAllowed(String)
        
        /// Thrown if a header's name contains spaces.
        case malformedHeader(String)
        
        /// Thrown if there are more than 10 categories in an email.
        case tooManyCategories
        
        /// Thrown if a category name exceeds 255 characters.
        case categoryTooLong(String)
        
        /// Thrown when there are too many substitutions.
        case tooManySubstitutions
        
        /// Thrown if a content type is used with a semicolon or CRLF character.
        case invalidContentType(String)
        
        /// Thrown when an email address is listed multiple times in an email.
        case duplicateRecipient(String)
        
        /// Thrown when the number of custom arguments exceeds 10,000 bytes.
        case tooManyCustomArguments(Int, String?)
        
        /// Thrown when an attachment's content ID contains invalid characters.
        case invalidContentID(String)
        
        /// Thrown when an attachment's filename contains invalid characters.
        case invalidFilename(String)
        
        // MARK: - Properties
        //=========================================================================
        
        /// A description for the error.
        public var description: String {
            switch self {
            case .malformedEmailAddress(let email):
                return String(format: NSLocalizedString(
                    "\"%@\" is not a valid email address. Please provide an RFC 5322 compliant email address.",
                    comment: "Malformed email address"), email)
                
            case .invalidScheduleDate:
                return NSLocalizedString(
                    "An email cannot be scheduled further than 72 hours in the future.",
                    comment: "Invalid schedule date")
                
            case .missingSubscriptionTrackingTag:
                return NSLocalizedString(
                    "When specifying plain text and HTML text for the subscription tracking setting, you must include the `<% %>` tag to indicate where the unsubscribe URL should be placed.",
                    comment: "Missing subscription tracking tag")
                
            case .missingRecipients:
                return NSLocalizedString(
                    "At least one recipient is required for a personalization.",
                    comment: "Missing recipients")
                
            case .thresholdOutOfRange(let threshold):
                return String(format: NSLocalizedString(
                    "The spam checker app only accepts a threshold which is between 1 and 10 (attempted to use %i)",
                    comment: "Threshold out of range"), threshold)
                
            case .tooManyUnsubscribeGroups:
                return NSLocalizedString(
                    "The `ASM` struct can have no more than 25 unsubscribe groups to display.",
                    comment: "Too many unsubscribe groups")
                
            case .invalidNumberOfPersonalizations:
                return String(format: NSLocalizedString(
                    "An `Email` must contain at least 1 personalization and cannot exceed %i personalizations.",
                    comment: "Invalid number of personalizations"), Constants.PersonalizationLimit)

            case .missingContent:
                return NSLocalizedString(
                    "An `Email` must contain at least 1 `Content` instance.",
                    comment: "Missing content")
                
            case .contentHasEmptyString:
                return NSLocalizedString(
                    "The `value` property on `Content` must be a string at least one character in length.",
                    comment: "Content has empty string")
                
            case .invalidContentOrder:
                return NSLocalizedString(
                    "When specifying the content of an email, the plain text version must be first (if present), followed by the HTML version (if present), and then any other content.",
                    comment: "Invalid content order")
                
            case .tooManyRecipients:
                return String(format: NSLocalizedString(
                    "Your `Email` instance contains too many recipients. The total number of recipients cannot exceed %i addresses. This includes all recipients defined within the `to`, `cc`, and `bcc` parameters, across each `Personalization` instance that you include in the personalizations array.",
                    comment: "Too many recipients"), Constants.RecipientLimit)
                
            case .missingSubject:
                return NSLocalizedString(
                    "An `Email` instance must contain a subject line for every personalization, and the subject line must contain at least 1 character. You can either define a global subject on the `Email` instance, add a subject line in every `Personalization` instance, or specify a template ID that contains a subject.",
                    comment: "Missing subject")
                
            case .headerNotAllowed(let header):
                return String(format: NSLocalizedString(
                    "The \"%@\" header is a reserved header, and cannot be used in the `headers` property.",
                    comment: "Header not allowed"), header)
                
            case .malformedHeader(let header):
                return String(format: NSLocalizedString(
                    "Invalid header \"%@\": When defining the headers that you would like to use, you must make sure that the header's name contains only ASCII characters and no spaces.",
                    comment: "Malformed header"), header)
                
            case .tooManyCategories:
                return String(format: NSLocalizedString(
                    "You cannot have more than %i categories associated with an email.",
                    comment: "Too many categories"), Constants.Categories.TotalLimit)
                
            case .categoryTooLong(let category):
                return String(format: NSLocalizedString(
                    "A category cannot have more than %i characters (attempted to use category named \"%@\").",
                    comment: "Category too long"), Constants.Categories.CharacterLimit, category)
                
            case .tooManySubstitutions:
                return String(format: NSLocalizedString(
                    "You cannot have more than %i substitutions in a personalization.",
                    comment: "Too many substitutions"), Constants.SubstitutionLimit)
                
            case .invalidContentType(let contentType):
                return String(format: NSLocalizedString(
                    "Invalid content type \"%@\": Content types cannot contain ‘;’, spaces, or CRLF characters, and must be at least 1 character long.",
                    comment: "Invalid content type"), contentType)
                
            case .duplicateRecipient(let recipient):
                return String(format: NSLocalizedString(
                    "Each unique email address in the `personalizations` array should only be included once. You have included \"%@\" more than once.",
                    comment: "Duplicate recipient"), recipient)
                
            case .tooManyCustomArguments(let amount, let args):
                var error = String(format: NSLocalizedString(
                    "Each personalized email cannot have custom arguments exceeding %i bytes. The email you're attempting to send has %i bytes.",
                    comment: "Too many custom arguments"), Constants.CustomArguments.MaximumBytes, amount)
                if let a = args {
                    error += "  " + NSLocalizedString(
                        "The offending custom args are below:",
                        comment: "Custom args exceeding max bytes") + "\n\n    \(a)"
                }
                return error
                
            case .invalidContentID(let contentID):
                return String(format: NSLocalizedString(
                    "Invalid content ID \"%@)\" for attachment: Content IDs cannot contain ‘;’, spaces, or CRLF characters, and must be at least 1 character long.",
                    comment: "Invalid content ID"), contentID)

            case .invalidFilename(let filename):
                return String(format: NSLocalizedString(
                    "Invalid filename %@ for attachment: Filenames cannot contain ‘;’, spaces, or CRLF characters, and must be at least 1 character long.",
                    comment: "Invalid filename"), filename)
            }
        }
    }
}

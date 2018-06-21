//
//  EmptyResponse.swift
//  SendGrid
//
//  Created by Scott Kawai on 6/21/18.
//

import Foundation

/// The `EmptyResponse` struct is used as the model type for any API call whose
/// response doesn't contain any body content. This exists since the `ModelType`
/// is a required specification when creating a request.
public struct EmptyResponse: Decodable {}

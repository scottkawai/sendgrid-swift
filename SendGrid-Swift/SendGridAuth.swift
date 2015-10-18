//
//  SendGridAuth.swift
//  SendGrid
//
//  Created by Scott Kawai on 10/18/15.
//  Copyright © 2015 SendGrid. All rights reserved.
//

import Foundation

enum SendGridAuth {
    case Credentials(username: String, password: String)
    case ApiKey(String)
}
//
//  Block.Get.swift
//  SendGrid
//
//  Created by Scott Kawai on 9/19/17.
//

import Foundation

public extension Block {
    
    /// The `Block.Get` class represents the API call to [retrieve the block
    /// list](https://sendgrid.com/docs/API_Reference/Web_API_v3/blocks.html#List-all-blocks-GET).
    public class Get: SuppressionListReader<Block> {
        
        /// The path to the blocks API.
        override var path: String { return "/v3/suppression/blocks" }
        
    }
    
}

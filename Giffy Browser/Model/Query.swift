//
//  Query.swift
//  Giffy Browser
//
//  Created by Vineet Rai on 19/03/21.
//

import Foundation

class Query {
    func query(query: String, offset: Int, limit: Int) -> RESTNetworkRequest {
       let parameters =   ["api_key" : "uX7V1S9dEQ1AQ38kLcG993r9MUyKHR5H",
                            "limit": "\(limit)",
                            "offset": "\(offset)"]
        
        return  RESTNetworkRequest(command: "v1/gifs/trending", parameters: parameters)
    }
}

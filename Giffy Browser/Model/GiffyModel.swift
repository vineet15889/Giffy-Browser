//
//  GiffyModel.swift
//  Giffy Browser
//
//  Created by Vineet Rai on 19/03/21.
//

import Foundation

// Swift 4 decodable is quite nice.

struct GiffyModel: Decodable {
    struct Record: Decodable {
        struct Original : Decodable {
            let frames: String?
            let url : String
        }
        
        struct Preview : Decodable {
            let url : String
        }
        
        struct Image: Decodable {
            let original : Preview
            let fixed_width_small : Original
        }
        
        let images: Image
        let slug: String
    }
    
    struct Pagination: Decodable {
        let count: Int
        let offset: Int
        let total_count: Int
    }
    
    struct Meta : Decodable {
        let msg: String
        let response_id: String
        let status: Int
    }
    
    let data: [Record]
    let meta: Meta
    let pagination: Pagination
    
    static func process(_ data: (Data)) -> CompletionData<GiffyModel> {
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(GiffyModel.self, from: data)
            return CompletionData.success(result)
        } catch let error {
            return CompletionData.error(error)
        }
    }
}

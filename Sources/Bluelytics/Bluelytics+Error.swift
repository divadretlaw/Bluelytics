//
//  Bluelytics+Error.swift
//  Bluelytics
//
//  Created by David Walter on 10.05.23.
//

import Foundation

extension Bluelytics {
    public enum Error: Swift.Error {
        case invalidQuery
        case invalidResponse
        case clientError(_ code: Int, message: String? = nil)
        case serverError(_ code: Int)
    }
    
    struct ErrorResponse: Decodable {
        let message: String
    }
}

//
//  Bluelytics+Error.swift
//  Bluelytics
//
//  Created by David Walter on 10.05.23.
//

import Foundation

extension Bluelytics {
    /// Bluelytics API Errors
    public enum Error: Swift.Error {
        /// The given query was invalid
        case invalidQuery
        /// The response was invalid
        case invalidResponse
        /// A client error occured
        ///
        /// - Parameters:
        ///     - code: The HTTP status code.
        ///     - message: The message of the error.
        case clientError(_ code: Int, message: String? = nil)
        /// A server error occured
        ///
        /// - Parameters:
        ///     - code: The HTTP status code.
        case serverError(_ code: Int)
    }
    
    struct ErrorResponse: Decodable {
        let message: String
    }
}

//
//  Bluelytics.swift
//  Bluelytics
//
//  Created by David Walter on 09.05.23.
//

import Foundation

public struct Bluelytics {
    private let session: URLSession
    private let host: URLComponents
    
    /// Initialize a new Bluelytics API
    ///
    /// - Parameters:
    ///     - host: The API host to call. Defaults to https://api.bluelytics.com.ar
    ///     - session: The `URLSession` to use. Defaults to `URLSession.shared`.
    public init(host: URL? = nil, session: URLSession = .shared) {
        self.session = session
        if let host {
            self.host = URLComponents(url: host, resolvingAgainstBaseURL: false) ?? URLComponents(string: "https://api.bluelytics.com.ar")!
        } else {
            self.host = URLComponents(string: "https://api.bluelytics.com.ar")!
        }
    }
    
    static var jsonDecoder: JSONDecoder = {
        let dateFormatter = DateFormatter()
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .custom { decoder -> Date in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.date(from: dateString) {
                return date
            }
            
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZZZZZ"
            if let date = dateFormatter.date(from: dateString) {
                return date
            }
            
            throw Error.invalidResponse
        }
        
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
    
    /// This endpoint returns the latest rates.
    ///
    /// - Returns: The current currency exchange rates
    public func latest() async throws -> Data {
        var components = host
        components.path = "/v2/latest"
        
        guard let url = components.url else { throw Bluelytics.Error.invalidQuery }
        
        let request = URLRequest(url: url)
        let (data, response) = try await session.data(for: request)
        return try decode(Data.self, from: data, with: response)
    }
    
    /// This endpoint returns a evolution series.
    ///
    /// - Parameters:
    ///     - days: Number of days to fetch. `nil` will fetch all available data
    ///
    /// - Returns: The evolution of the exchange rates
    public func evolution(days: Int? = nil) async throws -> [Entry] {
        var components = host
        components.queryItems = [
            URLQueryItem(name: "days", amount: days)
        ]
        .compactMap { $0 }
        components.path = "/v2/evolution.json"
        
        guard let url = components.url else { throw Bluelytics.Error.invalidQuery }
        
        let request = URLRequest(url: url)
        let (data, response) = try await session.data(for: request)
        return try decode([Entry].self, from: data, with: response)
    }
    
    private func decode<T>(_ type: T.Type, from data: Foundation.Data, with response: URLResponse) throws -> T where T: Decodable {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw Bluelytics.Error.invalidResponse
        }
        
        switch httpResponse.statusCode / 100 {
        case 4:
            do {
                let errorResponse = try Bluelytics.jsonDecoder.decode(ErrorResponse.self, from: data)
                throw Bluelytics.Error.clientError(httpResponse.statusCode, message: errorResponse.message)
            } catch {
                throw Bluelytics.Error.clientError(httpResponse.statusCode)
            }
        case 5:
            throw Bluelytics.Error.serverError(httpResponse.statusCode)
        default:
            return try Bluelytics.jsonDecoder.decode(T.self, from: data)
        }
    }
}

extension URLQueryItem {
    init?(name: String, amount: Int?) {
        guard let amount else { return nil }
        self.init(name: name, value: amount.description)
    }
}

//
//  Bluelytics+Models.swift
//  Bluelytics
//
//  Created by David Walter on 10.05.23.
//

import Foundation

extension Bluelytics {
    /// Response data from the API
    public struct Data: Codable, Equatable, Hashable, Sendable {
        /// Official government rate in US Dollar
        public let oficial: Value
        /// Free market rate in US Dollar
        public let blue: Value
        /// Official government rate in Euro
        public let oficialEuro: Value
        /// Free market rate in US Euro
        public let blueEuro: Value
        
        /// Date when the data was last updated
        public let lastUpdate: Date
    }
    
    /// Response data from the API
    public struct Value: Codable, Equatable, Hashable, Sendable {
        /// Average rate overall
        public let valueAvg: Double
        /// Sell (ask) value, average rate asked for by sellers
        public let valueSell: Double
        /// Buy (bid) value, average rate bidded for by buyers
        public let valueBuy: Double
    }
    
    /// Entry data from the API
    public struct Entry: Codable, Equatable, Hashable, Identifiable, Sendable {
        /// Date for this exchange rate
        public let date: Date
        /// Type of exchange rate (Oficial is the government rate, Blue is the free market)
        public let source: Source
        /// Sell (ask) value, average rate asked for by sellers
        public let valueSell: Double
        /// Buy (bid) value, average rate bidded for by buyers
        public let valueBuy: Double
        
        /// Average rate overall
        public var valueAvg: Double {
            (valueSell + valueBuy) / 2
        }
        
        public var id: String {
            "\(source.rawValue)-\(Int(date.timeIntervalSince1970))"
        }
    }
    
    /// Source of the entry
    public enum Source: String, Codable, Equatable, Hashable, Sendable, CustomStringConvertible {
        /// Official government rate
        case official = "Oficial"
        /// Free market rate
        case blue = "Blue"
        
        public var description: String {
            rawValue
        }
    }
}

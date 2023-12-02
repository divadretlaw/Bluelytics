import XCTest
@testable import Bluelytics

final class BluelyticsTests: XCTestCase {
    var bluelytics: Bluelytics!
    
    override func setUp() async throws {
        try await super.setUp()
        
        self.bluelytics = Bluelytics()
    }
    
    func testLatest() async throws {
        let data = try await bluelytics.latest()
        
        let calculatedOfficialAverage = (data.oficial.valueBuy + data.oficial.valueSell) / 2
        let differenceOfficial = abs(data.oficial.valueAvg - calculatedOfficialAverage)
        XCTAssertTrue(differenceOfficial < 10)
        
        let calculatedBlueAverage = (data.blue.valueBuy + data.blue.valueSell) / 2
        let differenceBlue = abs(data.blue.valueAvg - calculatedBlueAverage)
        XCTAssertTrue(differenceBlue < 10)
    }
    
    func testEvolution() async throws {
        let data = try await bluelytics.evolution(days: 7)
        XCTAssertEqual(data.count, 7)
    }
}

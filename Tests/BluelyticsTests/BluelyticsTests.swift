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
        print(data)
    }
    
    func testEvolution() async throws {
        let data = try await bluelytics.evolution(days: 7)
        print(data)
    }
}

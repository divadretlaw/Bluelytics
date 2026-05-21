import Foundation
import Testing
@testable import Bluelytics

struct BluelyticsTests {
    let bluelytics = Bluelytics()

    @Test func latest() async throws {
        let data = try await bluelytics.latest()

        let calculatedOfficialAverage = (data.oficial.valueBuy + data.oficial.valueSell) / 2
        let differenceOfficial = abs(data.oficial.valueAvg - calculatedOfficialAverage)
        // If the difference between received and calculated average is less than 10, we assume we got proper data
        #expect(differenceOfficial < 10)

        let calculatedBlueAverage = (data.blue.valueBuy + data.blue.valueSell) / 2
        let differenceBlue = abs(data.blue.valueAvg - calculatedBlueAverage)
        // If the difference between received and calculated average is less than 10, we assume we got proper data
        #expect(differenceBlue < 10)
    }

    @Test func evolution() async throws {
        let data = try await bluelytics.evolution(days: 7)
        // If the we get the same amount of data we requested, we assume we got proper data
        #expect(data.count == 7)
    }
}

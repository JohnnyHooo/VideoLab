import XCTest
@testable import VideoLab

final class VideoLabTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let composition = RenderComposition()
        XCTAssertNotNil(composition)
    }
}

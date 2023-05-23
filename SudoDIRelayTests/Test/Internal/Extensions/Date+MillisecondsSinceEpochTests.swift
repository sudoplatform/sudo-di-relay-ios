//
// Copyright © 2023 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest
@testable import SudoDIRelay

class DateMillisecondsSinceEpochTests: XCTestCase {

    func testCreateDateFromMilliseconds() {
        let inputMilliseconds = 1000.0
        let expectedDate = Date(timeIntervalSince1970: 1.0)
        let actualDate = Date(millisecondsSince1970: inputMilliseconds)
        XCTAssertEqual(expectedDate, actualDate)
    }

    func testMillisecondsSince1970() {
        let expectedMilliseconds = 1.0 * 1000
        let date = Date(timeIntervalSince1970: 1.0)
        XCTAssertEqual(date.millisecondsSince1970, expectedMilliseconds)
    }
}

//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import XCTest
@testable import SudoDIRelay

class PostboxTests: XCTestCase {

    func test_Postbox_Equitable() {
        let first = Postbox(
            connectionId: "connectionId",
            userId: "userId",
            sudoId: "sudoId",
            timestamp: Date(millisecondsSince1970: 0)
        )

        let second = Postbox(
            connectionId: "connectionId",
            userId: "userId",
            sudoId: "sudoId",
            timestamp: Date(millisecondsSince1970: 0)
        )
        XCTAssertEqual(first, second)
    }

    func test_Postbox_CorrectValues() {
        let postbox = Postbox(
            connectionId: "connectionId",
            userId: "userId",
            sudoId: "sudoId",
            timestamp: Date(millisecondsSince1970: 0)
        )
        XCTAssertEqual(postbox.sudoId, "sudoId")
        XCTAssertEqual(postbox.connectionId, "connectionId")
        XCTAssertEqual(postbox.userId, "userId")
        XCTAssertEqual(postbox.timestamp, Date(millisecondsSince1970: 0))
    }
}

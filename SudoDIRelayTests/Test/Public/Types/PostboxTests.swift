//
// Copyright © 2023 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import XCTest
@testable import SudoDIRelay

class PostboxTests: XCTestCase {

    func test_Postbox_Equatable() {
        let first = Postbox(
            id: "postbox-id",
            createdAt: Date(millisecondsSince1970: 1.0),
            updatedAt: Date(millisecondsSince1970: 2.0),
            ownerId: "owner-id",
            sudoId: "sudo-id",
            connectionId: "connection-id",
            isEnabled: true,
            serviceEndpoint: "https://service-endpoint"
        )

        let second = Postbox(
            id: "postbox-id",
            createdAt: Date(millisecondsSince1970: 1.0),
            updatedAt: Date(millisecondsSince1970: 2.0),
            ownerId: "owner-id",
            sudoId: "sudo-id",
            connectionId: "connection-id",
            isEnabled: true,
            serviceEndpoint: "https://service-endpoint"
        )
        XCTAssertEqual(first, second)
    }

    func test_Postbox_CorrectValues() {
        let postbox = Postbox(
                id: "postbox-id",
                createdAt: Date(millisecondsSince1970: 1.0),
                updatedAt: Date(millisecondsSince1970: 2.0),
                ownerId: "owner-id",
                sudoId: "sudo-id",
                connectionId: "connection-id",
                isEnabled: true,
                serviceEndpoint: "https://service-endpoint"
        )
        XCTAssertEqual(postbox.id, "postbox-id")
        XCTAssertEqual(postbox.sudoId, "sudo-id")
        XCTAssertEqual(postbox.ownerId, "owner-id")
        XCTAssertEqual(postbox.createdAt, Date(millisecondsSince1970: 1.0))
        XCTAssertEqual(postbox.updatedAt, Date(millisecondsSince1970: 2.0))
        XCTAssertEqual(postbox.connectionId, "connection-id")
        XCTAssertEqual(postbox.isEnabled, true)
        XCTAssertEqual(postbox.serviceEndpoint, "https://service-endpoint")

    }
}

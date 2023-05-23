//
// Copyright © 2023 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest
@testable import SudoDIRelay

class DefaultSudoDIRelayClientListPostboxes: DefaultSudoDIRelayTestCase {

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
    }

    // MARK: - Properties

    let now = Date.now

    // MARK: - Tests: ListPostboxes

    func test_listPostboxes_RespectsFailure() async {
        mockRelayService.listPostboxesError = SudoDIRelayError.accountLocked
        do {
            try _ = await instanceUnderTest.listPostboxes(limit: nil, nextToken: nil)
            XCTFail("Unexpected success.")
        } catch {
            XCTAssertEqual(mockRelayService.listPostboxesLastProperties?.0, nil)
            XCTAssertEqual(mockRelayService.listPostboxesLastProperties?.1, nil)
            XCTAssertErrorsEqual(error, SudoDIRelayError.accountLocked)
        }
    }

    func test_listPostboxes_SuccessResult() async {

        let expected = ListOutput<Postbox>(
            items: [Postbox(
                id: "postbox-id",
                createdAt: now,
                updatedAt: now,
                ownerId: "owner-id",
                sudoId: "sudo-id",
                connectionId: "connection-id",
                isEnabled: true,
                serviceEndpoint: "https://service-endpoint.com"
            )], nextToken: nil)
        mockRelayService.listPostboxesResult = expected

        do {
            let created = try await instanceUnderTest.listPostboxes( limit: 4, nextToken: "next-token")
            XCTAssertEqual(created, expected)
            XCTAssertEqual(mockRelayService.listPostboxesLastProperties?.0, 4)
            XCTAssertEqual(mockRelayService.listPostboxesLastProperties?.1, "next-token")
        } catch {
            XCTFail("Unexpected error: \(error)")

        }
    }
}

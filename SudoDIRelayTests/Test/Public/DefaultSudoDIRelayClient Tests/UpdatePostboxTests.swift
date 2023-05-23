//
// Copyright © 2023 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest
@testable import SudoDIRelay

class DefaultSudoDIRelayClientUpdatePostbox: DefaultSudoDIRelayTestCase {

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
    }

    // MARK: - Properties

    let now = Date.now

    // MARK: - Tests: updatePostbox

    func test_updatePostbox_RespectsFailure() async {
        mockRelayService.updatePostboxError = SudoDIRelayError.unauthorizedPostboxAccess
        do {
            try _ = await instanceUnderTest.updatePostbox(withPostboxId: "postbox-id", isEnabled: false)
            XCTFail("Unexpected success.")
        } catch {
            XCTAssertEqual(mockRelayService.updatePostboxLastProperties?.0, "postbox-id")
            XCTAssertEqual(mockRelayService.updatePostboxLastProperties?.1, false)
            XCTAssertErrorsEqual(error, SudoDIRelayError.unauthorizedPostboxAccess)
        }
    }

    func test_updatePostbox_SuccessResult() async {
        let expected = Postbox(
            id: "postbox-id",
            createdAt: now,
            updatedAt: now,
            ownerId: "owner-id",
            sudoId: "sudo-id",
            connectionId: "my-connection-id",
            isEnabled: true,
            serviceEndpoint: "https://service-endpoint.com")
        mockRelayService.updatePostboxResult = expected
        do {
            let deleted = try await instanceUnderTest.updatePostbox(
                withPostboxId: "postbox-id", isEnabled: true)
            XCTAssertEqual(deleted, expected)
            XCTAssertEqual(mockRelayService.updatePostboxLastProperties?.0, "postbox-id")
            XCTAssertEqual(mockRelayService.updatePostboxLastProperties?.1, true)
        } catch {
            XCTFail("Unexpected error: \(error)")

        }
    }
}

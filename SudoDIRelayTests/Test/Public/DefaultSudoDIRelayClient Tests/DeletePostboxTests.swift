//
// Copyright © 2023 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest
@testable import SudoDIRelay

class DefaultSudoDIRelayClientDeletePostbox: DefaultSudoDIRelayTestCase {

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
    }

    // MARK: - Tests: deletePostbox

    func test_deletePostbox_RespectsFailure() async {
        mockRelayService.deletePostboxError = SudoDIRelayError.unauthorizedPostboxAccess
        do {
            try _ = await instanceUnderTest.deletePostbox(withPostboxId: "postbox-id")
            XCTFail("Unexpected success.")
        } catch {
            XCTAssertEqual(mockRelayService.deletePostboxLastProperty, "postbox-id")
            XCTAssertErrorsEqual(error, SudoDIRelayError.unauthorizedPostboxAccess)
        }
    }

    func test_deletePostbox_SuccessResult() async {
        mockRelayService.deletePostboxResult = "postbox-id"

        do {
            let deleted = try await instanceUnderTest.deletePostbox(
                withPostboxId: "postbox-id")
            XCTAssertEqual(deleted, "postbox-id")
            XCTAssertEqual(mockRelayService.deletePostboxLastProperty, "postbox-id")
        } catch {
            XCTFail("Unexpected error: \(error)")

        }
    }
}

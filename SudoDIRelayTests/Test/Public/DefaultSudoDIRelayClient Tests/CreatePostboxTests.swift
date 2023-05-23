//
// Copyright © 2023 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest
@testable import AWSAppSync
@testable import SudoDIRelay

class DefaultSudoDIRelayClientCreatePostbox: DefaultSudoDIRelayTestCase {

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
    }

    // MARK: - Properties

    let now = Date.now

    // MARK: - Tests: createPostbox

    func test_createPostbox_RespectsFailure() async {
        mockRelayService.createPostboxError = SudoDIRelayError.invalidPostboxInput
        do {
            try _ = await instanceUnderTest.createPostbox(withConnectionId: "connection-id", ownershipProofToken: "dummyProof", isEnabled: false)
            XCTFail("Unexpected success.")
        } catch {
            XCTAssertEqual(mockRelayService.createPostboxLastProperties?.0, "connection-id")
            XCTAssertEqual(mockRelayService.createPostboxLastProperties?.1, "dummyProof")
            XCTAssertEqual(mockRelayService.createPostboxLastProperties?.2, false)
            XCTAssertErrorsEqual(error, SudoDIRelayError.invalidPostboxInput)
        }
    }

    func test_createPostbox_SuccessResult() async {
        let expected = Postbox(
            id: "postbox-id",
            createdAt: now,
            updatedAt: now,
            ownerId: "owner-id",
            sudoId: "sudo-id",
            connectionId: "my-connection-id",
            isEnabled: true,
            serviceEndpoint: "https://service-endpoint.com")
        mockRelayService.createPostboxResult = expected

        do {
            let created = try await instanceUnderTest.createPostbox(
                withConnectionId: "my-connection-id",
                ownershipProofToken: "dummyProof",
                isEnabled: true)
            XCTAssertEqual(created, expected)
            XCTAssertEqual(mockRelayService.createPostboxLastProperties?.0, "my-connection-id")
            XCTAssertEqual(mockRelayService.createPostboxLastProperties?.1, "dummyProof")
            XCTAssertEqual(mockRelayService.createPostboxLastProperties?.2, true)
        } catch {
            XCTFail("Unexpected error: \(error)")

        }
    }
}

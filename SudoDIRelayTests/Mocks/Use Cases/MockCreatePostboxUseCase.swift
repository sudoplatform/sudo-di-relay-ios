//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

@testable import SudoDIRelay

class MockCreatePostboxUseCase: CreatePostboxUseCase {

    init() {
        let relayService = MockRelayService()
        super.init(relayService: relayService)
    }

    var executeCallCount = 0
    var executeLastProperties: (String?, String?)?
    var executeError: Error?

    override func execute(withConnectionId connectionId: String, ownershipProofToken: String) async throws {
        executeCallCount += 1
        executeLastProperties = (connectionId, ownershipProofToken)

        if let executeError = executeError {
            throw executeError
        }
    }
}

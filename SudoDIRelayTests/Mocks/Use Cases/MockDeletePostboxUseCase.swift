//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

@testable import SudoDIRelay

class MockDeletePostboxUseCase: DeletePostboxUseCase {

    init() {
        let relayService = MockRelayService()
        super.init(relayService: relayService)
    }

    var executeCallCount = 0
    var executeLastProperty: String?
    var executeError: Error?

    override func execute(withConnectionId connectionId: String) async throws {
        executeCallCount += 1
        executeLastProperty = connectionId

        if let executeError = executeError {
            throw executeError
        }
    }
}

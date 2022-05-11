//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

@testable import SudoDIRelay

class MockListMessagesUseCase: ListMessagesUseCase {

    typealias ExecuteResult = [RelayMessage]

    init(result: ExecuteResult? = nil) {
        let relayService = MockRelayService()
        super.init(relayService: relayService)
        if let result = result {
            executeResult = result
        }
    }

    var executeCallCount = 0
    var executeLastProperty: String?
    var executeResult: ExecuteResult?
    var executeError: Error?

    override func execute(withConnectionId connectionId: String) async throws -> [RelayMessage] {
        executeCallCount += 1
        executeLastProperty = connectionId

        if let executeError = executeError {
            throw executeError
        }

        if let executeResult = executeResult {
            return executeResult
        }

        throw AnyError("Ensure that the return result of `execute` is set in `MockListMessagesUseCase`")
    }
}

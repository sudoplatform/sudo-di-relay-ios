//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

@testable import SudoDIRelay

class MockSubscribeToPostboxDeletedUseCase: SubscribeToPostboxDeletedUseCase {

    typealias ExecuteResult = Result<Status, Error>

    init(result: ExecuteResult? = nil) {
        let relayService = MockRelayService()
        super.init(relayService: relayService)
        if let result = result {
            executeResult = result
        }
    }

    var executeCallCount = 0
    var executeLastProperty: String?
    var executeResult: ExecuteResult = .failure(AnyError("Please add base result to MockSubscribeToPostboxDeleted.execute"))
    var executeReturnResult = MockSubscriptionToken()

    override func execute(
        withConnectionId connectionId: String,
        completion: @escaping ClientCompletion<Status>
    ) -> SubscriptionToken? {
        executeCallCount += 1
        executeLastProperty = connectionId
        completion(executeResult)
        return executeReturnResult
    }
}

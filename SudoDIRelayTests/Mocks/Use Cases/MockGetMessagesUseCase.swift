//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

@testable import SudoDIRelay

class MockGetMessagesUseCase: GetMessagesUseCase {

    typealias ExecuteResult = Result<[RelayMessage], Error>

    init(result: ExecuteResult? = nil) {
        let relayService = MockRelayService()
        super.init(relayService: relayService)
        if let result = result {
            executeResult = result
        }
    }

    var executeCallCount = 0
    var executeLastProperty: String?
    var executeResult: ExecuteResult = .failure(AnyError("Please add base result to MockGetMessagesUseCase.execute"))

    override func execute(withConnectionId connectionId: String, completion: @escaping ClientCompletion<[RelayMessage]>) {
        executeCallCount += 1
        executeLastProperty = connectionId
        completion(executeResult)
    }
}

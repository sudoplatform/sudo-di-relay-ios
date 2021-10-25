//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

@testable import SudoDIRelay

class MockStoreMessageUseCase: StoreMessageUseCase {

    typealias ExecuteResult = Result<RelayMessage?, Error>

    init(result: ExecuteResult? = nil) {
        let relayService = MockRelayService()
        super.init(relayService: relayService)
        if let result = result {
            executeResult = result
        }
    }

    var executeCallCount = 0
    var executeLastProperties: (connectionId: String?, message: String?)?
    var executeResult: ExecuteResult = .failure(AnyError("Please add base result to MockStoreMessageUseCase.execute"))

    override func execute(withConnectionId connectionId: String, message: String, completion: @escaping ClientCompletion<RelayMessage?>) {
        executeCallCount += 1
        executeLastProperties = (connectionId, message)
        completion(executeResult)
    }
}

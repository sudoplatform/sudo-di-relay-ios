//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//
import Foundation
@testable import SudoDIRelay

class MockGetPostboxEndpointUseCase: GetPostboxEndpointUseCase {

    typealias ExecuteResult = URL?

    init(result: ExecuteResult? = nil) {
        let relayService = MockRelayService()
        super.init(relayService: relayService)
        if let result = result {
            executeReturnResult = result
        }
    }

    var executeCallCount = 0
    var executeLastProperty: String?
    var executeReturnResult: URL?

    override func execute(withConnectionId connectionId: String) -> URL? {
        executeCallCount += 1
        executeLastProperty = connectionId
        return executeReturnResult
    }
}

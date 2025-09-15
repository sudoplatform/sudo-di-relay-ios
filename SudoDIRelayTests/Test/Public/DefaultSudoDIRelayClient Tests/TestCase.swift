//
// Copyright © 2023 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest
import SudoUser
import SudoApiClient
@testable import SudoDIRelay

class DefaultSudoDIRelayTestCase: XCTestCase {

    // MARK: - Properties

    var instanceUnderTest: DefaultSudoDIRelayClient!
    var graphQLClient: SudoApiClient!
    var mockRelayService: MockRelayService!
    var mockUserClient: MockSudoUserClient!

    // MARK: - Lifecycle

    override func setUp() {
        super.setUp()
        mockUserClient = MockSudoUserClient()
        graphQLClient = MockSudoApiClient()

        mockRelayService = MockRelayService()
        instanceUnderTest = DefaultSudoDIRelayClient(
            sudoApiClient: graphQLClient,
            sudoUserClient: mockUserClient,
            relayService: mockRelayService)
    }
}

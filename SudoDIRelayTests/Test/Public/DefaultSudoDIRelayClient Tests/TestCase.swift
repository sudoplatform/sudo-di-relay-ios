//
// Copyright © 2023 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest
import AWSAppSync
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
        guard let (graphQLClient, _) = try? MockAWSAppSyncClientGenerator.generate(logger: .testLogger, sudoUserClient: mockUserClient) else {
            XCTFail("Failed to mock AppSyncClientGenerator")
            return
        }

        mockRelayService = MockRelayService()
        instanceUnderTest = DefaultSudoDIRelayClient(
            sudoApiClient: graphQLClient,
            sudoUserClient: mockUserClient,
            relayService: mockRelayService)
    }
}

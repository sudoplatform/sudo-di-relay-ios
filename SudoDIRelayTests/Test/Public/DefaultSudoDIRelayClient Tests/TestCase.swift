//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest
import AWSAppSync
import SudoUser
@testable import SudoDIRelay

class DefaultSudoDIRelayTestCase: XCTestCase {

    // MARK: - Properties

    var instanceUnderTest: DefaultSudoDIRelayClient!
    var appSyncClient: AWSAppSyncClient!
    var mockAppSyncClientHelper: MockAppSyncClientHelper!
    var mockUseCaseFactory: MockUseCaseFactory!
    var mockRelayService: MockRelayService!
    var mockUserClient: MockSudoUserClient!

    // MARK: - Lifecycle

    override func setUp() {
        super.setUp()
        appSyncClient = MockAWSAppSyncClientGenerator.generateClient()
        do {
            mockAppSyncClientHelper = try MockAppSyncClientHelper()
        } catch {
            XCTFail("Unable to set up MockAppSyncClientHelper.")
            return
        }
        mockRelayService = MockRelayService()
        mockUseCaseFactory = MockUseCaseFactory(relayService: mockRelayService)
        mockUserClient = MockSudoUserClient()
        instanceUnderTest = DefaultSudoDIRelayClient(
            appSyncClient: appSyncClient,
            appSyncClientHelper: mockAppSyncClientHelper,
            sudoUserClient: mockUserClient,
            useCaseFactory: mockUseCaseFactory,
            relayService: mockRelayService)
    }

    // MARK: - Utilities

}

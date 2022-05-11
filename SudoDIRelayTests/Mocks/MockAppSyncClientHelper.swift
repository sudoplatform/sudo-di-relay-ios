//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import AWSAppSync
import SudoApiClient
import SudoUser
@testable import SudoDIRelay
import XCTest

class MockAppSyncClientHelper: AppSyncClientHelper {

    // MARK: - Properties

    var getHttpEndpointCalled: Bool = false
    var getSudoApiClientCalled: Bool = false

    private var sudoUserClient: MockSudoUserClient!
    private var sudoApiClient: SudoApiClient!
    private var mockTransport: MockAWSNetworkTransport!

    // MARK: - Lifecycle

    init() throws {
        self.sudoUserClient = MockSudoUserClient()
        guard let (graphQLClient, mockTransport) = try? MockAWSAppSyncClientGenerator.generate(logger: .testLogger, sudoUserClient: sudoUserClient) else {
            XCTFail("Failed to mock AppSyncClientGenerator")
            return
        }
        self.sudoApiClient = graphQLClient
        self.mockTransport = mockTransport
    }

    func getMockTransport() -> MockAWSNetworkTransport {
        return mockTransport
    }

    func getMockUserClient() -> MockSudoUserClient {
        return sudoUserClient
    }

    // MARK: - Conformance: AppSyncClientHelper

    func getSudoApiClient() -> SudoApiClient {
        getSudoApiClientCalled = true
        return sudoApiClient
    }

    func getHttpEndpoint() -> String {
        getHttpEndpointCalled = true
        return "test.com"
    }
}

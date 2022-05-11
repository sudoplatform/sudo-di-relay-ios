//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest
@testable import SudoDIRelay

class DefaultSudoDIRelayClientGetPostboxEndpointTests: DefaultSudoDIRelayTestCase {

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
    }

    // MARK: - Tests: GetPostboxEndpoint

    func test_getPostboxEndpoint_CreatesUseCase() {
        _ = instanceUnderTest.getPostboxEndpoint(withConnectionId: "dummyId")
        XCTAssertEqual(mockUseCaseFactory.generateGetPostboxEndpointUseCaseCallCount, 1)
    }

    func test_getPostboxEndpoint_CallsUseCaseExecute() {
        let mockUseCase = MockGetPostboxEndpointUseCase()
        mockUseCaseFactory.generateGetPostboxEndpointUseCaseResult = mockUseCase
        _ = instanceUnderTest.getPostboxEndpoint(withConnectionId: "dummyId")
        XCTAssertEqual(mockUseCase.executeCallCount, 1)
        XCTAssertEqual(mockUseCase.executeLastProperty, "dummyId")
    }

    func test_getPostboxEndpoint_SuccessResult() {
        let expectedResult = URL(string: "test.com/dummyId")
        let mockUseCase = MockGetPostboxEndpointUseCase(result: expectedResult)
        mockUseCaseFactory.generateGetPostboxEndpointUseCaseResult = mockUseCase
        let result = self.instanceUnderTest.getPostboxEndpoint(withConnectionId: "dummyId")
        XCTAssertEqual(expectedResult, result)
    }
}

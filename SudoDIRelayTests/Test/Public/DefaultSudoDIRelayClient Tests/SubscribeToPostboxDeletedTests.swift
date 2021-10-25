//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest
@testable import SudoDIRelay

class DefaultSudoDIRelayClientSubscribeToPostboxDeleted: DefaultSudoDIRelayTestCase {

    // MARK: - Tests

    func test_subscribeToPostboxDeleted_CreatesUseCase() {
        _ = instanceUnderTest.subscribeToPostboxDeleted(withConnectionId: "dummyId") { _ in }
        XCTAssertEqual(mockUseCaseFactory.generateSubscribeToPostboxDeletedUseCaseCallCount, 1)
    }

    func test_subscribeToPostboxDeleted_ReturnsSubscriptionTokenFromUseCase() {
        let mockUseCase = MockSubscribeToPostboxDeletedUseCase()
        mockUseCase.executeReturnResult = MockSubscriptionToken()
        mockUseCaseFactory.generateSubscribeToPostboxDeletedUseCaseResult = mockUseCase
        let returnedToken = instanceUnderTest.subscribeToPostboxDeleted(withConnectionId: "dummyId") { _ in }
        XCTAssertTrue(returnedToken === mockUseCase.executeReturnResult)
    }

    func test_subscribeToPostboxDeleted_CallsExecuteOnUseCase() {
        let mockUseCase = MockSubscribeToPostboxDeletedUseCase()
        mockUseCaseFactory.generateSubscribeToPostboxDeletedUseCaseResult = mockUseCase
        _ = instanceUnderTest.subscribeToPostboxDeleted(withConnectionId: "dummyId") { _ in }
        XCTAssertEqual(mockUseCase.executeCallCount, 1)
    }

    func test_subscribeToPostboxDeleted_RespectsReturnedUseCaseError() {
        let mockUseCase = MockSubscribeToPostboxDeletedUseCase(result: .failure(AnyError("Failure from subscription")))
        mockUseCaseFactory.generateSubscribeToPostboxDeletedUseCaseResult = mockUseCase
        waitUntil { done in
            _ = self.instanceUnderTest.subscribeToPostboxDeleted(withConnectionId: "dummyId") { result in
                defer { done() }
                switch result {
                case let .failure(error as AnyError):
                    XCTAssertEqual(error, AnyError("Failure from subscription"))
                    done()
                default:
                    XCTFail("Unexpected result: \(result)")
                }
            }
        }
    }

    func test_subscribeToPostboxDeleted_ReturnsUseCaseResult() {
        let outputEntity = DataFactory.Domain.okStatus
        let mockUseCase = MockSubscribeToPostboxDeletedUseCase(result: .success(outputEntity))
        mockUseCaseFactory.generateSubscribeToPostboxDeletedUseCaseResult = mockUseCase
        waitUntil { done in
            _ = self.instanceUnderTest.subscribeToPostboxDeleted(withConnectionId: "dummyId") { result in
                defer { done() }
                switch result {
                case .success(let status):
                    XCTAssertEqual(status, Status.ok)
                    done()
                default:
                    XCTFail("Unexpected result: \(result)")
                }
            }
        }
    }

}

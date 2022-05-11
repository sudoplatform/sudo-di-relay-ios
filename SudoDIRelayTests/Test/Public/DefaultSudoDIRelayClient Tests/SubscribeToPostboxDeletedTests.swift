//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest
@testable import SudoDIRelay

class DefaultSudoDIRelayClientSubscribeToPostboxDeleted: DefaultSudoDIRelayTestCase {

    // MARK: - Tests

    func test_subscribeToPostboxDeleted_CreatesUseCase() async {
        do {
            _ = try await instanceUnderTest.subscribeToPostboxDeleted(withConnectionId: "dummyId") { _ in }
            XCTAssertEqual(mockUseCaseFactory.generateSubscribeToPostboxDeletedUseCaseCallCount, 1)
        } catch {
            XCTFail("Unexpected error \(error)")
        }
    }

    func test_subscribeToPostboxDeleted_ReturnsSubscriptionTokenFromUseCase() async {
        let mockUseCase = MockSubscribeToPostboxDeletedUseCase()
        mockUseCase.executeReturnResult = MockSubscriptionToken()
        mockUseCaseFactory.generateSubscribeToPostboxDeletedUseCaseResult = mockUseCase

        do {
            let returnedToken = try await instanceUnderTest.subscribeToPostboxDeleted(withConnectionId: "dummyId") { _ in }
            XCTAssertTrue(returnedToken === mockUseCase.executeReturnResult)
        } catch {
            XCTFail("Unexpected error \(error)")
        }
    }

    func test_subscribeToPostboxDeleted_CallsExecuteOnUseCase() async {
        let mockUseCase = MockSubscribeToPostboxDeletedUseCase()
        mockUseCaseFactory.generateSubscribeToPostboxDeletedUseCaseResult = mockUseCase

        do {
            _ = try await instanceUnderTest.subscribeToPostboxDeleted(withConnectionId: "dummyId") { _ in }
            XCTAssertEqual(mockUseCase.executeCallCount, 1)
        } catch {
            XCTFail("Unexpected error \(error)")
        }

    }

    func test_subscribeToPostboxDeleted_RespectsReturnedUseCaseError() async {
        let mockUseCase = MockSubscribeToPostboxDeletedUseCase(result: .failure(AnyError("Failure from subscription")))
        mockUseCaseFactory.generateSubscribeToPostboxDeletedUseCaseResult = mockUseCase

        do {
            _ = try await instanceUnderTest.subscribeToPostboxDeleted(withConnectionId: "dummyId") { result in
                switch result {
                case let .failure(error as AnyError):
                    XCTAssertEqual(error, AnyError("Failure from subscription"))
                default:
                    XCTFail("Unexpected result: \(result)")
                }
            }
        } catch {
            XCTFail("Unexpected error \(error)")
        }
    }

    func test_subscribeToPostboxDeleted_ReturnsUseCaseResult() async {
        let outputEntity = DataFactory.Domain.okStatus
        let mockUseCase = MockSubscribeToPostboxDeletedUseCase(result: .success(outputEntity))
        mockUseCaseFactory.generateSubscribeToPostboxDeletedUseCaseResult = mockUseCase

        do {
            _ = try await self.instanceUnderTest.subscribeToPostboxDeleted(withConnectionId: "dummyId") { result in
                switch result {
                case .success(let status):
                    XCTAssertEqual(status, Status.ok)
                default:
                    XCTFail("Unexpected result: \(result)")
                }
            }
        } catch {
            XCTFail("Unexpected error \(error)")
        }
    }

}

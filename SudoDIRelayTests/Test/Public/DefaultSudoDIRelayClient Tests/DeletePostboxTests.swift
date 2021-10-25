//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest
@testable import SudoDIRelay

class DefaultSudoDIRelayClientDeletePostbox: DefaultSudoDIRelayTestCase {

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
    }

    // MARK: - Properties

    let utcTimestamp = "Thu, 1 Jan 1970 00:00:00 GMT+00"

    // MARK: - Tests: deletePostbox

    func test_deletePostbox_CreatesUseCase() {
        instanceUnderTest.deletePostbox(withConnectionId: "dummyId") { _ in }
        XCTAssertEqual(mockUseCaseFactory.generateDeletePostboxUseCaseCallCount, 1)
    }

    func test_deletePostbox_CallsUseCaseExecute() {
        let mockUseCase = MockDeletePostboxUseCase()
        mockUseCaseFactory.generateDeletePostboxUseCaseResult = mockUseCase
        instanceUnderTest.deletePostbox(withConnectionId: "dummyId") {_ in }
        XCTAssertEqual(mockUseCase.executeCallCount, 1)
        XCTAssertEqual(mockUseCase.executeLastProperty, "dummyId")
    }

    func test_deletePostbox_RespectsUseCaseFailure() {
        let mockUseCase = MockDeletePostboxUseCase(result: .failure(AnyError("Delete failed")))
        mockUseCaseFactory.generateDeletePostboxUseCaseResult = mockUseCase
        waitUntil { done in
            self.instanceUnderTest.deletePostbox(withConnectionId: "dummyId") { result in
                defer { done() }
                switch result {
                case let .failure(error as AnyError):
                    XCTAssertEqual(error, AnyError("Delete failed"))
                default:
                    XCTFail("Unexpected result: \(result)")
                }
            }
        }
    }

    func test_deletePostbox_SuccessResult() {
        let mockUseCase = MockDeletePostboxUseCase(result: .success(()))
        mockUseCaseFactory.generateDeletePostboxUseCaseResult = mockUseCase
        waitUntil { done in
            self.instanceUnderTest.deletePostbox(withConnectionId: "dummyId") { result in
                defer { done() }
                switch result {
                case .success():
                    break
                default:
                    XCTFail("Unexpected result: \(result)")
                }
            }
        }
    }
}

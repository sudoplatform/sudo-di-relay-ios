//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest
@testable import SudoDIRelay

class DefaultSudoDIRelayClientCreatePostbox: DefaultSudoDIRelayTestCase {

    // MARK: - Lifecycle
    override func setUp() {
        super.setUp()
    }

    // MARK: - Properties

    let utcTimestamp = "Thu, 1 Jan 1970 00:00:00 GMT+00"

    // MARK: - Tests: createPostbox

    func test_createPostbox_CreatesUseCase() {
        instanceUnderTest.createPostbox(withConnectionId: "dummyId") { _ in }
        XCTAssertEqual(mockUseCaseFactory.generateCreatePostboxUseCaseCallCount, 1)
    }

    func test_createPostbox_CallsUseCaseExecute() {
        let mockUseCase = MockCreatePostboxUseCase()
        mockUseCaseFactory.generateCreatePostboxUseCaseResult = mockUseCase
        instanceUnderTest.createPostbox(withConnectionId: "dummyId") {_ in }
        XCTAssertEqual(mockUseCase.executeCallCount, 1)
        XCTAssertEqual(mockUseCase.executeLastProperty, "dummyId")
    }

    func test_createPostbox_RespectsUseCaseFailure() {
        let mockUseCase = MockCreatePostboxUseCase(result: .failure(AnyError("Create failed")))
        mockUseCaseFactory.generateCreatePostboxUseCaseResult = mockUseCase
        waitUntil { done in
            self.instanceUnderTest.createPostbox(withConnectionId: "dummyId") { result in
                defer { done() }
                switch result {
                case let .failure(error as AnyError):
                    XCTAssertEqual(error, AnyError("Create failed"))
                default:
                    XCTFail("Unexpected result: \(result)")
                }
            }
        }
    }

    func test_createPostbox_SuccessResult() {
        let mockUseCase = MockCreatePostboxUseCase(result: .success(()))
        mockUseCaseFactory.generateCreatePostboxUseCaseResult = mockUseCase
        waitUntil { done in
            self.instanceUnderTest.createPostbox(withConnectionId: "dummyId") { result in
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

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

    func test_deletePostbox_CreatesUseCase() async {
        do {
            try await instanceUnderTest.deletePostbox(withConnectionId: "dummyId")
            XCTAssertEqual(mockUseCaseFactory.generateDeletePostboxUseCaseCallCount, 1)
        } catch {
            XCTFail("Unexpected error \(error)")
        }
    }

    func test_deletePostbox_CallsUseCaseExecute() async {
        let mockUseCase = MockDeletePostboxUseCase()
        mockUseCaseFactory.generateDeletePostboxUseCaseResult = mockUseCase

        do {
            try await instanceUnderTest.deletePostbox(withConnectionId: "dummyId")
            XCTAssertEqual(mockUseCase.executeCallCount, 1)
            XCTAssertEqual(mockUseCase.executeLastProperty, "dummyId")
        } catch {
            XCTFail("Unexpected error \(error)")
        }
    }

    func test_deletePostbox_RespectsUseCaseFailure() async {
        let mockUseCase = MockDeletePostboxUseCase()
        mockUseCase.executeError = AnyError("Delete failed")
        mockUseCaseFactory.generateDeletePostboxUseCaseResult = mockUseCase

        do {
            try await instanceUnderTest.deletePostbox(withConnectionId: "dummyId")
        } catch {
            XCTAssertErrorsEqual(error, AnyError("Delete failed"))
        }

    }

    func test_deletePostbox_SuccessResult() async {
        let mockUseCase = MockDeletePostboxUseCase()
        mockUseCaseFactory.generateDeletePostboxUseCaseResult = mockUseCase

        do {
            try await instanceUnderTest.deletePostbox(withConnectionId: "dummyId")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}

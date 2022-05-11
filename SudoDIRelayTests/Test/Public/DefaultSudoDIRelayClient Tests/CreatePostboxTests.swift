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

    func test_createPostbox_CreatesUseCase() async {
        do {
            try await instanceUnderTest.createPostbox(withConnectionId: "dummyId", ownershipProofToken: "dummyProof")
            XCTAssertEqual(mockUseCaseFactory.generateCreatePostboxUseCaseCallCount, 1)
        } catch {
            XCTFail("Unexpected error")
        }
    }

    func test_createPostbox_CallsUseCaseExecute() async {
        let mockUseCase = MockCreatePostboxUseCase()
        mockUseCaseFactory.generateCreatePostboxUseCaseResult = mockUseCase
        do {
            try await instanceUnderTest.createPostbox(withConnectionId: "dummyId", ownershipProofToken: "dummyProof")
            XCTAssertEqual(mockUseCase.executeCallCount, 1)
            XCTAssertEqual(mockUseCase.executeLastProperties?.0, "dummyId")
            XCTAssertEqual(mockUseCase.executeLastProperties?.1, "dummyProof")
        } catch {
            XCTFail("Unexpected error")
        }
    }

    func test_createPostbox_RespectsUseCaseFailure() async {
        let mockUseCase = MockCreatePostboxUseCase()
        mockUseCase.executeError = AnyError("Create failed")
        mockUseCaseFactory.generateCreatePostboxUseCaseResult = mockUseCase

        do {
            try await instanceUnderTest.createPostbox(withConnectionId: "dummyId", ownershipProofToken: "dummyProof")
            XCTFail("Unexpected success.")
        } catch {
            XCTAssertErrorsEqual(error, AnyError("Create failed"))
        }
    }

    func test_createPostbox_SuccessResult() async {
        let mockUseCase = MockCreatePostboxUseCase()
        mockUseCaseFactory.generateCreatePostboxUseCaseResult = mockUseCase

        do {
            try await instanceUnderTest.createPostbox(withConnectionId: "dummyId", ownershipProofToken: "dummyProof")
        } catch {
            XCTFail("Unexpected error: \(error)")

        }
    }
}

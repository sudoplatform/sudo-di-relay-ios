//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest
import SudoLogging
@testable import SudoDIRelay

class CreatePostboxUseCaseTests: XCTestCase {

    // MARK: - Properties

    var instanceUnderTest: CreatePostboxUseCase!
    var mockRelayService: MockRelayService!

    // MARK: - Lifecycle

    override func setUp() {
        mockRelayService = MockRelayService()
        instanceUnderTest = CreatePostboxUseCase(relayService: mockRelayService)
    }

    // MARK: - Tests

    func test_initializer() {
        let instanceUnderTest = CreatePostboxUseCase(relayService: mockRelayService)
        XCTAssertTrue(instanceUnderTest.relayService === mockRelayService)
    }

    func test_execute_CallsCreatePostboxCorrectly() async {
        do {
            try await instanceUnderTest.execute(withConnectionId: "dummyId", ownershipProofToken: "dummyToken")
            XCTAssertEqual(mockRelayService.createPostboxCallCount, 1)
            XCTAssertEqual(mockRelayService.createPostboxLastProperties?.0, "dummyId")
            XCTAssertEqual(mockRelayService.createPostboxLastProperties?.1, "dummyToken")
        } catch {
            XCTFail("Unexpected error \(error)")
        }

    }

    func test_execute_RespectsCreatePostboxFailure() async {
        mockRelayService.createPostboxError = AnyError("Create failed")
        do {
            try await self.instanceUnderTest.execute(withConnectionId: "dummyId", ownershipProofToken: "dummyToken")
            XCTFail("Unexpected success")
        } catch {
            XCTAssertErrorsEqual(error, AnyError("Create failed"))
        }
    }

    func test_execute_CreatePoxtboxReturnsVoidSuccess() async {
        do {
            try await self.instanceUnderTest.execute(withConnectionId: "dummyId", ownershipProofToken: "dummyToken")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}

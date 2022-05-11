//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest
@testable import SudoDIRelay

class DeletePostboxUseCaseTests: XCTestCase {

    // MARK: - Properties

    var instanceUnderTest: DeletePostboxUseCase!
    var mockRelayService: MockRelayService!

    // MARK: - Lifecycle

    override func setUp() {
        mockRelayService = MockRelayService()
        instanceUnderTest = DeletePostboxUseCase(relayService: mockRelayService)
    }
    // MARK: - Tests

    func test_initializer() {
        let instanceUnderTest = DeletePostboxUseCase(relayService: mockRelayService)
        XCTAssertTrue(instanceUnderTest.relayService === mockRelayService)
    }

    func test_execute_CallsDeletePostboxCorrectly() async {
        do {
            try await instanceUnderTest.execute(withConnectionId: "dummyId")
            XCTAssertEqual(mockRelayService.deletePostboxCallCount, 1)
            XCTAssertEqual(mockRelayService.deletePostboxLastProperty, "dummyId")
        } catch {
            XCTFail("Unexpected error \(error)")
        }
    }

    func test_execute_RespectsDeletePostboxFailure() async {
        mockRelayService.deletePostboxError = AnyError("Delete failed")

        do {
            try await instanceUnderTest.execute(withConnectionId: "dummyId")
            XCTFail("Unexpected success")
        } catch {
            XCTAssertErrorsEqual(error, AnyError("Delete failed"))
        }
    }

    func test_execute_ReturnsVoidDeletePostboxSuccessResult() async {
        do {
            try await instanceUnderTest.execute(withConnectionId: "dummyId")
        } catch {
            XCTFail("Unexpected result: \(error)")

        }
    }
}

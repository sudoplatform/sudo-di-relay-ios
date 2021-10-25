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

    func test_execute_CallsDeletePostboxCorrectly() {
        instanceUnderTest.execute(withConnectionId: "dummyId") { _ in }
        XCTAssertEqual(mockRelayService.deletePostboxCallCount, 1)
        XCTAssertEqual(mockRelayService.deletePostboxLastProperty, "dummyId")
    }

    func test_execute_RespectsDeletePostboxFailure() {
        mockRelayService.deletePostboxResult = .failure(AnyError("Delete failed"))
        waitUntil { done in
            self.instanceUnderTest.execute(withConnectionId: "dummyId") { result in
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

    func test_execute_ReturnsVoidDeletePostboxSuccessResult() {
        mockRelayService.deletePostboxResult = .success(())
        waitUntil { done in
            self.instanceUnderTest.execute(withConnectionId: "dummyId") { result in
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

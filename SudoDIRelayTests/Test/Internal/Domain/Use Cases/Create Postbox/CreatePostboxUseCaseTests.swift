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

    var connectionId: String!

    // MARK: - Lifecycle

    override func setUp() {
        mockRelayService = MockRelayService()
        instanceUnderTest = CreatePostboxUseCase(relayService: mockRelayService)
        connectionId = UUID().uuidString
    }

    // MARK: - Tests

    func test_initializer() {
        let instanceUnderTest = CreatePostboxUseCase(relayService: mockRelayService)
        XCTAssertTrue(instanceUnderTest.relayService === mockRelayService)
    }

    func test_execute_CallsCreatePostboxCorrectly() {
        instanceUnderTest.execute(withConnectionId: connectionId) { _ in }
        XCTAssertEqual(mockRelayService.createPostboxCallCount, 1)
        XCTAssertEqual(mockRelayService.createPostboxLastProperty, connectionId)
    }

    func test_execute_RespectsCreatePostboxFailure() {
        mockRelayService.createPostboxResult = .failure(AnyError("Create failed"))
        waitUntil { done in
            self.instanceUnderTest.execute(withConnectionId: "dummyId") { result in
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

    func test_execute_CreatePoxtboxReturnsVoidSuccess() {
        mockRelayService.createPostboxResult = .success(())
        waitUntil { done in
            self.instanceUnderTest.execute(withConnectionId: "dummyId"
            ) { result in
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

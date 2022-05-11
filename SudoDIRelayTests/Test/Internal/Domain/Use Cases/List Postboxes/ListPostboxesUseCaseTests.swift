//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest
import SudoLogging
@testable import SudoDIRelay

class ListPostboxesUseCaseTests: XCTestCase {

    // MARK: - Properties

    var instanceUnderTest: ListPostboxesUseCase!

    var mockRelayService: MockRelayService!

    var sudoId: String!

    // MARK: - Lifecycle

    override func setUp() {
        mockRelayService = MockRelayService()
        instanceUnderTest = ListPostboxesUseCase(relayService: mockRelayService)
        sudoId = UUID().uuidString
    }

    // MARK: - Tests

    func test_initializer() {
        let instanceUnderTest = ListPostboxesUseCase(relayService: mockRelayService)
        XCTAssertTrue(instanceUnderTest.relayService === mockRelayService)
    }

    func test_execute_CallslistPostboxesUseCaseCorrectly() async {
        mockRelayService.listPostboxesResult = []

        do {
            _ = try await instanceUnderTest.execute(withSudoId: sudoId)
            XCTAssertEqual(mockRelayService.listPostboxesCallCount, 1)
            XCTAssertEqual(mockRelayService.listPostboxesLastProperty, sudoId)
        } catch {
            XCTFail("Unexpected error \(error)")
        }
    }

    func test_execute_RespectslistPostboxesFailure() async {
        mockRelayService.listPostboxesError = AnyError("List postboxes failed")

        do {
            _ = try await instanceUnderTest.execute(withSudoId: sudoId)
        } catch {
            XCTAssertErrorsEqual(error, AnyError("List postboxes failed"))
        }
    }

    func test_execute_ReturnsCorrectlistPostboxesUseCaseResult() async {
        mockRelayService.listPostboxesResult = [DataFactory.Domain.postbox]
        do {
            let postboxes = try await instanceUnderTest.execute(withSudoId: sudoId)
            XCTAssertEqual(postboxes.count, 1)
            XCTAssertEqual(postboxes[0].sudoId, "sudoId")
            XCTAssertEqual(postboxes[0].userId, "userId")
            XCTAssertEqual(postboxes[0].connectionId, "id")
            XCTAssertEqual(postboxes[0].timestamp, Date(millisecondsSince1970: 0))
        } catch {
            XCTFail("Unexpected error \(error)")
        }
    }
}

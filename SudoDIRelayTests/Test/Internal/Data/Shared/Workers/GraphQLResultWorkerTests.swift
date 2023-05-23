//
// Copyright © 2023 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest
// Required to test the internal of GraphQLResult
@testable import AWSAppSync
@testable import SudoDIRelay

class GraphQLResultWorkerTests: XCTestCase {

    let instanceUnderTest = GraphQLResultWorker()

    func test_convertToResult_ReturnsPassedInError() {
        let error = AnyError("Error")
        let graphQLResult: GraphQLResult<String>? = nil
        let result = instanceUnderTest.convertToResult(graphQLResult, error: error)
        switch result {
        case let .failure(error as SudoDIRelayError):
            XCTAssertEqual(error, .internalError("Error"))
        default:
            XCTFail("Unexpected result: \(result)")
        }
    }

    func test_convertToResult_ReturnsDefaultErrorIfNoErrorOrResultPassedIn() {
        let graphQLResult: GraphQLResult<String>? = nil
        let result = instanceUnderTest.convertToResult(graphQLResult, error: nil)
        switch result {
        case let .failure(error as SudoDIRelayError):
            XCTAssertEqual(error, .internalError("Invalid result returned from Relay Service"))
        default:
            XCTFail("Unexpected result: \(result)")
        }
    }

    func test_convertToResult_RespectsResultError() {
        let graphQLError = GraphQLError("GraphQL Failure")
        let graphQLResult: GraphQLResult<String>? = .init(data: nil, errors: [graphQLError], source: .cache, dependentKeys: nil)
        let result = instanceUnderTest.convertToResult(graphQLResult, error: nil)
        switch result {
        case let .failure(error as SudoDIRelayError):
            XCTAssertEqual(error, .internalError("GraphQL Failure"))
        default:
            XCTFail("Unexpected result: \(result)")
        }
    }

    func test_convertToResult_ReturnsDefaultErrorIfNoDataOnResult() {
        let graphQLResult: GraphQLResult<String>? = .init(data: nil, errors: nil, source: .cache, dependentKeys: nil)
        let result = instanceUnderTest.convertToResult(graphQLResult, error: nil)
        switch result {
        case let .failure(error as SudoDIRelayError):
            XCTAssertEqual(error, .internalError("Invalid result returned from Relay Service"))
        default:
            XCTFail("Unexpected result: \(result)")
        }
    }

    func test_invalidResult_ReturnsDefaultResponseIfNoInputError() {
        let result: Swift.Result<String, Error> = instanceUnderTest.invalidResult()
        switch result {
        case let .failure(error as SudoDIRelayError):
            XCTAssertEqual(error, .internalError("Invalid result returned from Relay Service"))
        default:
            XCTFail("Unexpected result: \(result)")
        }
    }

    func test_invalidResult_ReturnsErrorAsSudoDIRelayErrorLocalizedDescription() {
        let error = AnyError("Failed to fail")
        let result: Swift.Result<String, Error> = instanceUnderTest.invalidResult(error)
        switch result {
        case let .failure(error as SudoDIRelayError):
            XCTAssertEqual(error, .internalError("Failed to fail"))
        default:
            XCTFail("Unexpected result: \(result)")
        }
    }

}

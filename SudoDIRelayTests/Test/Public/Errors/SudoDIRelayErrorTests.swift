//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest
// This is only testable to initialize GraphQLError for testing
@testable import AWSAppSync
@testable import SudoDIRelay
import SudoOperations

class SudoDIRelayErrorTests: XCTestCase {

    func constructGraphQLErrorWithErrorType(_ type: String?) -> GraphQLError {
        guard let type = type else {
            return GraphQLError([:])
        }
        let obj: [String: Any] = [
            "errorType": type
        ]
        return GraphQLError(obj)
    }

    // MARK: - Tests: GraphQL Initializer

    func test_init_graphQL_InvalidInitMessage() {
        let graphQLError = constructGraphQLErrorWithErrorType("sudoplatform.relay.InvalidInitMessage")
        let error = SudoDIRelayError(graphQLError: graphQLError)
        XCTAssertEqual(error, .invalidInitMessage)
    }

    func test_init_graphQL_NoErrorTypeReturnsNil() {
        let graphQLError = constructGraphQLErrorWithErrorType(nil)
        let error = SudoDIRelayError(graphQLError: graphQLError)
        XCTAssertNil(error)
    }

    func test_init_graphQL_UnsupportedReturnsNil() {
        let graphQLError = constructGraphQLErrorWithErrorType("foo-bar")
        let error = SudoDIRelayError(graphQLError: graphQLError)
        XCTAssertNil(error)
    }

    // MARK: - Tests: SudoPlatformError Initializer

    func test_init_sudoPlatformError_ServiceError() {
        let sudoPlatformError: SudoPlatformError = .serviceError
        let error = SudoDIRelayError(platformError: sudoPlatformError)
        XCTAssertEqual(error, .serviceError)
    }

    func test_init_sudoPlatformError_DecodingError() {
        let sudoPlatformError: SudoPlatformError = .decodingError
        let error = SudoDIRelayError(platformError: sudoPlatformError)
        XCTAssertEqual(error, .decodingError)
    }

    func test_init_sudoPlatformError_EnvironmentError() {
        let sudoPlatformError: SudoPlatformError = .environmentError
        let error = SudoDIRelayError(platformError: sudoPlatformError)
        XCTAssertEqual(error, .environmentError)
    }

    func test_init_sudoPlatformError_PolicyFailed() {
        let sudoPlatformError: SudoPlatformError = .policyFailed
        let error = SudoDIRelayError(platformError: sudoPlatformError)
        XCTAssertEqual(error, .policyFailed)
    }

    func test_init_sudoPlatformError_InvalidTokenError() {
        let sudoPlatformError: SudoPlatformError = .invalidTokenError
        let error = SudoDIRelayError(platformError: sudoPlatformError)
        XCTAssertEqual(error, .invalidTokenError)
    }

    func test_init_sudoPlatformError_AccountLockedError() {
        let sudoPlatformError: SudoPlatformError = .accountLockedError
        let error = SudoDIRelayError(platformError: sudoPlatformError)
        XCTAssertEqual(error, .accountLockedError)
    }

    func test_init_sudoPlatformError_IdentityInsufficient() {
        let sudoPlatformError: SudoPlatformError = .identityInsufficient
        let error = SudoDIRelayError(platformError: sudoPlatformError)
        XCTAssertEqual(error, .identityInsufficient)
    }

    func test_init_sudoPlatformError_IdentityNotVerified() {
        let sudoPlatformError: SudoPlatformError = .identityNotVerified
        let error = SudoDIRelayError(platformError: sudoPlatformError)
        XCTAssertEqual(error, .identityNotVerified)
    }

    func test_init_sudoPlatformError_InternalError_RespectsNil() {
        let sudoPlatformError: SudoPlatformError = .internalError(cause: nil)
        let error = SudoDIRelayError(platformError: sudoPlatformError)
        XCTAssertEqual(error, .internalError(nil))
    }

    func test_init_sudoPlatformError_InternalError() {
        let sudoPlatformError: SudoPlatformError = .internalError(cause: "foobar")
        let error = SudoDIRelayError(platformError: sudoPlatformError)
        XCTAssertEqual(error, .internalError("foobar"))
    }

    // MARK: - Tests: ErrorDescription

    func test_errorDescription_InvalidConfig() {
        let L10Ndescription = L10n.Relay.Errors.invalidConfig
        let errorDescription = SudoDIRelayError.invalidConfig.errorDescription
        XCTAssertEqual(errorDescription, L10Ndescription)
    }

    func test_errorDescription_NotSignedIn() {
        let L10Ndescription = L10n.Relay.Errors.notSignedIn
        let errorDescription = SudoDIRelayError.notSignedIn.errorDescription
        XCTAssertEqual(errorDescription, L10Ndescription)
    }

    func test_errorDescription_InvalidInitMessage() {
        let L10Ndescription = L10n.Relay.Errors.invalidInitMessage
        let errorDescription = SudoDIRelayError.invalidInitMessage.errorDescription
        XCTAssertEqual(errorDescription, L10Ndescription)
    }

    func test_errorDescription_ServiceError() {
        let L10Ndescription = L10n.Relay.Errors.serviceError
        let errorDescription = SudoDIRelayError.serviceError.errorDescription
        XCTAssertEqual(errorDescription, L10Ndescription)
    }

    func test_errorDescription_DecodingError() {
        let L10Ndescription = L10n.Relay.Errors.decodingError
        let errorDescription = SudoDIRelayError.decodingError.errorDescription
        XCTAssertEqual(errorDescription, L10Ndescription)
    }

    func test_errorDescription_EnvironmentError() {
        let L10Ndescription = L10n.Relay.Errors.environmentError
        let errorDescription = SudoDIRelayError.environmentError.errorDescription
        XCTAssertEqual(errorDescription, L10Ndescription)
    }

    func test_errorDescription_PolicyFailed() {
        let L10Ndescription = L10n.Relay.Errors.policyFailed
        let errorDescription = SudoDIRelayError.policyFailed.errorDescription
        XCTAssertEqual(errorDescription, L10Ndescription)
    }

    func test_errorDescription_InvalidTokenError() {
        let L10Ndescription = L10n.Relay.Errors.invalidTokenError
        let errorDescription = SudoDIRelayError.invalidTokenError.errorDescription
        XCTAssertEqual(errorDescription, L10Ndescription)
    }

    func test_errorDescription_AccountLockedError() {
        let L10Ndescription = L10n.Relay.Errors.accountLockedError
        let errorDescription = SudoDIRelayError.accountLockedError.errorDescription
        XCTAssertEqual(errorDescription, L10Ndescription)
    }

    func test_errorDescription_IdentityInsufficient() {
        let L10Ndescription = L10n.Relay.Errors.identityInsufficient
        let errorDescription = SudoDIRelayError.identityInsufficient.errorDescription
        XCTAssertEqual(errorDescription, L10Ndescription)
    }

    func test_errorDescription_IdentityNotVerified() {
        let L10Ndescription = L10n.Relay.Errors.identityNotVerified
        let errorDescription = SudoDIRelayError.identityNotVerified.errorDescription
        XCTAssertEqual(errorDescription, L10Ndescription)
    }

    func test_errorDescription_InternalError_RespectsNil() {
        let expectedDescription = "Internal Error"
        let errorDescription = SudoDIRelayError.internalError(nil).errorDescription
        XCTAssertEqual(errorDescription, expectedDescription)
    }

    func test_errorDescription_InternalError_Cause() {
        let expectedDescription = "Foo Bar"
        let errorDescription = SudoDIRelayError.internalError("Foo Bar").errorDescription
        XCTAssertEqual(errorDescription, expectedDescription)
    }

    // MARK: - Tests: Misc

    func test_localizedDescriptionRespected() {
        let expectedDescription = L10n.Relay.Errors.accountLockedError
        let actualDescription = (SudoDIRelayError.accountLockedError as Error).localizedDescription
        XCTAssertEqual(expectedDescription, actualDescription)
    }
}

//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import XCTest
// This is only testable to initialize GraphQLError for testing
@testable import SudoDIRelay
// Necessary for GraphQLError creation
@testable import AWSAppSync
@testable import SudoApiClient

class SudoDIRelayErrorTests: XCTestCase {

    func constructGraphQLErrorWithErrorType(_ type: String?) -> GraphQLError {
        guard let type = type else {
            return GraphQLError([
                "message": "message" // Must add a message due to force unwrap in AWSAppSync
            ])
        }
        let obj: [String: Any] = [
            "errorType": type,
            "message": "message"
        ]
        return GraphQLError(obj)
    }

    func generateGraphQLError(errorType: String) -> GraphQLError {
        return GraphQLError([
            "errorType": errorType,
            "message": "message"
        ])
    }

    // MARK: - Tests: GraphQL Initializer

    func test_init_graphQL_InvalidInitMessage() {
        let graphQLError = generateGraphQLError(errorType: "sudoplatform.relay.InvalidInitMessage")
        let error = SudoDIRelayError(graphQLError: graphQLError)
        XCTAssertErrorsEqual(error, SudoDIRelayError.invalidInitMessage)
    }

    func test_init_graphQL_NoErrorTypeReturnsMessage() {
        let graphQLError = constructGraphQLErrorWithErrorType(nil)
        let error = SudoDIRelayError(graphQLError: graphQLError)
        XCTAssertErrorsEqual(error, SudoDIRelayError.internalError("message"))
    }

    func test_init_graphQL_UnsupportedReturnsInternalError() {
        let graphQLError = generateGraphQLError(errorType: "foo-bar")
        let error = SudoDIRelayError(graphQLError: graphQLError)
        XCTAssertErrorsEqual(error, SudoDIRelayError.internalError("foo-bar - message"))
    }

    func test_init_graphQL_DecodingError() {
        let graphQLError = constructGraphQLErrorWithErrorType("sudoplatform.DecodingError")
        let error = SudoDIRelayError(graphQLError: graphQLError)
        XCTAssertErrorsEqual(error, SudoDIRelayError.decodingError)
    }

    func test_init_graphQL_EnvironmentError() {
        let graphQLError = constructGraphQLErrorWithErrorType("sudoplatform.EnvironmentError")
        let error = SudoDIRelayError(graphQLError: graphQLError)
        XCTAssertErrorsEqual(error, SudoDIRelayError.environmentError)
    }

    func test_init_graphQL_PolicyFailed() {
        let graphQLError = constructGraphQLErrorWithErrorType("sudoplatform.PolicyFailed")
        let error = SudoDIRelayError(graphQLError: graphQLError)
        XCTAssertErrorsEqual(error, SudoDIRelayError.policyFailed)
    }

    func test_init_graphQL_InvalidTokenError() {
        let graphQLError = constructGraphQLErrorWithErrorType("sudoplatform.relay.InvalidTokenError")
        let error = SudoDIRelayError(graphQLError: graphQLError)
        XCTAssertErrorsEqual(error, SudoDIRelayError.invalidTokenError)
    }

    func test_init_GraphQL_AccountLockedError() {
        let graphQLError = constructGraphQLErrorWithErrorType("sudoplatform.AccountLocked")
        let error = SudoDIRelayError(graphQLError: graphQLError)
        XCTAssertErrorsEqual(error, SudoDIRelayError.accountLocked)
    }

    func test_init_GraphQL_IdentityInsufficient() {
        let graphQLError = constructGraphQLErrorWithErrorType("sudoplatform.IdentityVerificationInsufficientError")
        let error = SudoDIRelayError(graphQLError: graphQLError)
        XCTAssertErrorsEqual(error, SudoDIRelayError.identityInsufficient)
    }

    func test_init_graphQL_IdentityNotVerified() {
        let graphQLError = constructGraphQLErrorWithErrorType("sudoplatform.IdentityVerificationNotVerifiedError")
        let error = SudoDIRelayError(graphQLError: graphQLError)
        XCTAssertErrorsEqual(error, SudoDIRelayError.identityNotVerified)
    }

    func test_init_graphQL_InternalError() {
        let graphQLError: GraphQLError = constructGraphQLErrorWithErrorType("foobar")
        let error = SudoDIRelayError(graphQLError: graphQLError)
        XCTAssertErrorsEqual(error, SudoDIRelayError.internalError("foobar - message"))
    }

    // MARK: - Tests: SudoPlatformError Initializer

    func test_init_sudoPlatformError_ServiceError() {
        let sudoPlatformError: ApiOperationError = .serviceError
        let error = SudoDIRelayError.fromApiOperationError(error: sudoPlatformError)
        XCTAssertEqual(error, .serviceError)
    }

    func test_init_sudoPlatformError_NotSignedIn() {
        let sudoPlatformError: ApiOperationError = .notSignedIn
        let error = SudoDIRelayError.fromApiOperationError(error: sudoPlatformError)
        XCTAssertEqual(error, .notSignedIn)
    }

    func test_init_sudoPlatformError_InsufficientEntitlements() {
        let sudoPlatformError: ApiOperationError = .insufficientEntitlements
        let error = SudoDIRelayError.fromApiOperationError(error: sudoPlatformError)
        XCTAssertEqual(error, .insufficientEntitlements)
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
        let L10Ndescription = L10n.Relay.Errors.accountLocked
        let errorDescription = SudoDIRelayError.accountLocked.errorDescription
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
        let expectedDescription = L10n.Relay.Errors.accountLocked
        let actualDescription = (SudoDIRelayError.accountLocked as Error).localizedDescription
        XCTAssertEqual(expectedDescription, actualDescription)
    }
}

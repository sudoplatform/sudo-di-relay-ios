//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//
import Foundation
@testable import SudoDIRelay

class MockRelayService: RelayService, Resetable {

    var resetCallCount = 0

    func reset() {
        resetCallCount += 1
    }

    // MARK: - ListMessages

    var listMessagesCallCount = 0
    var listMessagesLastProperty: String = ""
    var listMessagesResult: [RelayMessage]?
    var listMessagesError: Error?

    func listMessages(
        withConnectionId connectionId: String
    ) async throws -> [RelayMessage] {
        listMessagesCallCount += 1
        listMessagesLastProperty = connectionId

        if let listMessagesError = listMessagesError {
            throw listMessagesError
        }

        if let listMessagesResult = listMessagesResult {
            return listMessagesResult
        }

        throw AnyError("Please add base result to`listMessages` in `MockRelayService`")
    }

    // MARK: - CreatePostbox

    var createPostboxCallCount = 0
    var createPostboxLastProperties: (String?, String?)?
    var createPostboxError: Error?

    func createPostbox(withConnectionId connectionId: String, ownershipProofToken: String) async throws {
        createPostboxCallCount += 1
        createPostboxLastProperties = (connectionId, ownershipProofToken)

        if let createPostboxError = createPostboxError {
            throw createPostboxError
        }
    }

    // MARK: - StoreMessage

    var storeMessageCallCount = 0
    var storeMessageLastProperty: String = ""
    var storeMessageResult: RelayMessage?
    var storeMessageError: Error?

    func storeMessage(withConnectionId connectionId: String, message: String) async throws -> RelayMessage? {
        storeMessageCallCount += 1
        storeMessageLastProperty = connectionId

        if let storeMessageError = storeMessageError {
            throw storeMessageError
        }

        return storeMessageResult
    }

    // MARK: - DeletePostbox

    var deletePostboxCallCount = 0
    var deletePostboxLastProperty: String = ""
    var deletePostboxError: Error?

    func deletePostbox(withConnectionId connectionId: String) async throws {
        deletePostboxCallCount += 1
        deletePostboxLastProperty = connectionId

        if let deletePostboxError = deletePostboxError {
            throw deletePostboxError
        }
    }

    // MARK: - SubscribeToMessagesReceived

    var subscribeToMessagesReceivedCallCount = 0
    var subscribeToMessagesReceivedLastProperty: String = ""
    var subscribeToMessagesReceivedResult: Result<RelayMessage, Error> = .failure(AnyError(
    "Please add base result to `MockRelayService.subscribeToMessagesReceived`"
    ))
    var subscribeToMessagesReceivedReturnResult: SubscriptionToken = MockSubscriptionToken()
    var subscribeToMessageReceivedError: Error?

    func subscribeToMessagesReceived(
        withConnectionId connectionId: String,
        resultHandler: @escaping ClientCompletion<RelayMessage>
    ) async throws -> SubscriptionToken {
        subscribeToMessagesReceivedCallCount += 1
        subscribeToMessagesReceivedLastProperty = connectionId
        resultHandler(subscribeToMessagesReceivedResult)

        if let subscribeToMessageReceivedError = subscribeToMessageReceivedError {
            throw subscribeToMessageReceivedError
        }

        return subscribeToMessagesReceivedReturnResult
    }

    // MARK: - SubscribeToPostboxDeleted

    var subscribeToPostboxDeletedCallCount = 0
    var subscribeToPostboxDeletedLastProperty: String = ""
    var subscribeToPostboxDeletedResult: Result<Status, Error> = .failure(AnyError(
    "Please add base result to `MockRelayService.subscribeToPostboxDeleted`"
    ))
    var subscribeToPostboxDeletedReturnResult: SubscriptionToken = MockSubscriptionToken()
    var subscribeToPostboxDeletedError: Error?

    func subscribeToPostboxDeleted(
        withConnectionId connectionId: String,
        resultHandler: @escaping ClientCompletion<Status>
    ) throws -> SubscriptionToken {
        subscribeToPostboxDeletedCallCount += 1
        subscribeToPostboxDeletedLastProperty = connectionId
        resultHandler(subscribeToPostboxDeletedResult)

        if let subscribeToPostboxDeletedError = subscribeToMessageReceivedError {
            throw subscribeToPostboxDeletedError
        }

        return subscribeToPostboxDeletedReturnResult
    }

    // MARK: - GetPostboxEndpoint

    var getPostboxEndpointCallCount = 0
    var getPostboxEndpointLastProperty: String = ""
    var getPostboxEndpointReturnResult: URL?

    func getPostboxEndpoint(withConnectionId connectionId: String) -> URL? {
        getPostboxEndpointCallCount += 1
        getPostboxEndpointLastProperty = connectionId
        return getPostboxEndpointReturnResult
    }

    // MARK: - listPostboxes

    var listPostboxesCallCount = 0
    var listPostboxesLastProperty: String = ""
    var listPostboxesResult: [Postbox]?
    var listPostboxesError: Error?

    func listPostboxes(withSudoId sudoId: String) async throws -> [Postbox] {
        listPostboxesCallCount += 1
        listPostboxesLastProperty = sudoId

        if let listPostboxesError = listPostboxesError {
            throw listPostboxesError
        }

        if let listPostboxesResult = listPostboxesResult {
            return listPostboxesResult
        }

        throw AnyError("Please add base result to `MockRelayService.listPostboxes`")
    }
}

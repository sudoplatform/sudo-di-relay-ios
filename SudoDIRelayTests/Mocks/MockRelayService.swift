//
// Copyright © 2023 Anonyome Labs, Inc. All rights reserved.
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
    var listMessagesLastProperties: (Int?, String?)?
    var listMessagesResult: ListOutput<Message>?
    var listMessagesError: Error?

    func listMessages(limit: Int?, nextToken: String?) async throws -> SudoDIRelay.ListOutput<SudoDIRelay.Message> {
        listMessagesCallCount += 1
        listMessagesLastProperties = (limit, nextToken)

        if let listMessagesError = listMessagesError {
            throw listMessagesError
        }

        if let listMessagesResult = listMessagesResult {
            return listMessagesResult
        }

        throw AnyError("Please add base result to`listMessages` in `MockRelayService`")
    }

    // MARK: - Subscribe

    var subscribeCallCount = 0
    var subscribeLastProperties: (String, SubscriptionNotificationType, Subscriber)?
    var subscribeError: Error?

    func subscribe(id: String, notificationType: SubscriptionNotificationType, subscriber: Subscriber) async throws {
        subscribeCallCount += 1
        subscribeLastProperties = (id, notificationType, subscriber)

        if let subscribeError = subscribeError {
            throw subscribeError
        }
    }

    // MARK: - Unsubscribe

    var unsubscribeCallCount = 0
    var unsubscribeLastId: String?

    func unsubscribe(id: String) async {
        unsubscribeCallCount += 1
        unsubscribeLastId = id
    }

    // MARK: - UnsubscribeAll
    var unsubscribeAllCallCount = 0

    func unsubscribeAll() async {
        unsubscribeAllCallCount += 1
    }

    // MARK: - DeleteMessage

    var deleteMessageCallCount = 0
    var deleteMessageLastMessageId: String = ""
    var deleteMessageResult: String?
    var deleteMessageError: Error?

    func deleteMessage(withMessageId messageId: String) async throws -> String {
        deleteMessageCallCount += 1
        deleteMessageLastMessageId = messageId

        if let deleteMessageError = deleteMessageError {
            throw deleteMessageError
        }

        if let deleteMessageResult = deleteMessageResult {
            return deleteMessageResult
        }

        throw AnyError("Please add base result to `deleteMessage` in `MockRelayService`")
    }

    // MARK: - BulkDeleteMessage

    var bulkDeleteMessageCallCount = 0
    var bulkDeleteMessageLastMessageIds: [String] = []
    var bulkDeleteMessageResult: [String]?
    var bulkDeleteMessageError: Error?

    func bulkDeleteMessage(withMessageIds messageIds: [String]) async throws -> [String] {
        bulkDeleteMessageCallCount += 1
        bulkDeleteMessageLastMessageIds = messageIds

        if let bulkDeleteMessageError = bulkDeleteMessageError {
            throw bulkDeleteMessageError
        }

        if let bulkDeleteMessageResult = bulkDeleteMessageResult {
            return bulkDeleteMessageResult
        }

        throw AnyError("Please add base result to `bulkDeleteMessage` in `MockRelayService`")
    }

    // MARK: - CreatePostbox

    var createPostboxCallCount = 0
    var createPostboxLastProperties: (String?, String?, Bool?)?
    var createPostboxResult: Postbox?
    var createPostboxError: Error?

    func createPostbox(withConnectionId connectionId: String, ownershipProofToken: String, isEnabled: Bool?) async throws -> SudoDIRelay.Postbox {
        createPostboxCallCount += 1
        createPostboxLastProperties = (connectionId, ownershipProofToken, isEnabled)

        if let createPostboxError = createPostboxError {
            throw createPostboxError
        }
        if let createPostboxResult = createPostboxResult {
            return createPostboxResult
        }

        throw AnyError("Please add base result to `MockRelayService.createPostbox`")
    }

    // MARK: - ListPostboxes

    var listPostboxesCallCount = 0
    var listPostboxesLastProperties: (Int?, String?)?
    var listPostboxesResult: ListOutput<Postbox>?
    var listPostboxesError: Error?

    func listPostboxes(limit: Int?, nextToken: String?) async throws -> SudoDIRelay.ListOutput<SudoDIRelay.Postbox> {
        listPostboxesCallCount += 1
        listPostboxesLastProperties = (limit, nextToken)

        if let listPostboxesError = listPostboxesError {
            throw listPostboxesError
        }

        if let listPostboxesResult = listPostboxesResult {
            return listPostboxesResult
        }

        throw AnyError("Please add base result to `MockRelayService.listPostboxes`")
    }

    // MARK: - UpdatePostbox

    var updatePostboxCallCount = 0
    var updatePostboxLastProperties: (String, Bool?)?
    var updatePostboxResult: Postbox?
    var updatePostboxError: Error?

    func updatePostbox(withPostboxId postboxId: String, isEnabled: Bool?) async throws -> SudoDIRelay.Postbox {
        updatePostboxCallCount += 1
        updatePostboxLastProperties = (postboxId, isEnabled)

        if let updatePostboxError = updatePostboxError {
            throw updatePostboxError
        }
        if let updatePostboxResult = updatePostboxResult {
            return updatePostboxResult
        }

        throw AnyError("Please add base result to `MockRelayService.updatePostbox`")
    }

    // MARK: - DeletePostbox

    var deletePostboxCallCount = 0
    var deletePostboxLastProperty: String = ""
    var deletePostboxResult: String?
    var deletePostboxError: Error?

    func deletePostbox(withPostboxId postboxId: String) async throws -> String {
        deletePostboxCallCount += 1
        deletePostboxLastProperty = postboxId

        if let deletePostboxError = deletePostboxError {
            throw deletePostboxError
        }
        if let deletePostboxResult = deletePostboxResult {
            return deletePostboxResult
        }

        throw AnyError("Please add base result to `MockRelayService.deletePostbox`")
    }

}

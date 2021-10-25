//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

@testable import SudoDIRelay

class MockRelayService: RelayService, Resetable {

    var resetCallCount = 0

    func reset() {
        resetCallCount += 1
    }

    // MARK: - GetMessages

    var getMessagesCallCount = 0
    var getMessagesLastProperty: String = ""
    var getMessagesResult: Result<[RelayMessage], Error> = .failure(
        AnyError("Please add base result to `MockRelayService.getMessages")
    )

    func getMessages(
        withConnectionId connectionId: String,
        completion: @escaping ClientCompletion<[RelayMessage]>
    ) {
        getMessagesCallCount += 1
        getMessagesLastProperty = connectionId
        completion(getMessagesResult)
    }

    // MARK: - CreatePostbox

    var createPostboxCallCount = 0
    var createPostboxLastProperty: String = ""
    var createPostboxResult: Result<Void, Error> = .failure(
        AnyError("Please add base result to `MockRelayService.createPostbox")
    )

    func createPostbox(
        withConnectionId connectionId: String,
        completion: @escaping ClientCompletion<Void>
    ) {
        createPostboxCallCount += 1
        createPostboxLastProperty = connectionId
        completion(createPostboxResult)
    }

    // MARK: - StoreMessage

    var storeMessageCallCount = 0
    var storeMessageLastProperty: String = ""
    var storeMessageResult: Result<RelayMessage?, Error> = .failure(
        AnyError("Please add base result to `MockRelayService.storeMessage")
    )

    func storeMessage(
        withConnectionId connectionId: String,
        message: String,
        completion: @escaping ClientCompletion<RelayMessage?>
    ) {
        storeMessageCallCount += 1
        storeMessageLastProperty = connectionId
        completion(storeMessageResult)
    }

    // MARK: - DeletePostbox

    var deletePostboxCallCount = 0
    var deletePostboxLastProperty: String = ""
    var deletePostboxResult: Result<Void, Error> = .failure(
        AnyError("Please add base result to `MockRelayService.deletePostbox")
    )

    func deletePostbox(
        withConnectionId connectionId: String,
        completion: @escaping ClientCompletion<Void>
    ) {
        deletePostboxCallCount += 1
        deletePostboxLastProperty = connectionId
        completion(deletePostboxResult)
    }

    // MARK: - SubscribeToMessagesReceived

    var subscribeToMessagesReceivedCallCount = 0
    var subscribeToMessagesReceivedLastProperty: String = ""
    var subscribeToMessagesReceivedResult: Result<RelayMessage, Error> = .failure(AnyError(
    "Please add base result to `MockRelayService.subscribeToMessagesReceived`"
    ))
    var subscribeToMessagesReceivedReturnResult: SubscriptionToken = MockSubscriptionToken()

    func subscribeToMessagesReceived(
        withConnectionId connectionId: String,
        resultHandler: @escaping ClientCompletion<RelayMessage>
    ) throws -> SubscriptionToken {
        subscribeToMessagesReceivedCallCount += 1
        subscribeToMessagesReceivedLastProperty = connectionId
        resultHandler(subscribeToMessagesReceivedResult)
        return subscribeToMessagesReceivedReturnResult
    }

    // MARK: - SubscribeToPostboxDeleted

    var subscribeToPostboxDeletedCallCount = 0
    var subscribeToPostboxDeletedLastProperty: String = ""
    var subscribeToPostboxDeletedResult: Result<Status, Error> = .failure(AnyError(
    "Please add base result to `MockRelayService.subscribeToPostboxDeleted`"
    ))
    var subscribeToPostboxDeletedReturnResult: SubscriptionToken = MockSubscriptionToken()

    func subscribeToPostboxDeleted(
        withConnectionId connectionId: String,
        resultHandler: @escaping ClientCompletion<Status>
    ) throws -> SubscriptionToken {
        subscribeToPostboxDeletedCallCount += 1
        subscribeToPostboxDeletedLastProperty = connectionId
        resultHandler(subscribeToPostboxDeletedResult)
        return subscribeToPostboxDeletedReturnResult
    }
}

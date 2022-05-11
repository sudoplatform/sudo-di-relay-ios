//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

@testable import SudoDIRelay

class MockUseCaseFactory: UseCaseFactory {

    // MARK: - ListMessages

    var generateListMessagesUseCaseCallCount = 0
    var generateListMessagesUseCaseResult: MockListMessagesUseCase?

    override func generateListMessages() -> ListMessagesUseCase {
        generateListMessagesUseCaseCallCount += 1
        guard let useCase = generateListMessagesUseCaseResult else {
            return super.generateListMessages()
        }
        return useCase
    }

    // MARK: - CreatePostbox

    var generateCreatePostboxUseCaseCallCount = 0
    var generateCreatePostboxUseCaseResult: MockCreatePostboxUseCase?

    override func generateCreatePostbox() -> CreatePostboxUseCase {
        generateCreatePostboxUseCaseCallCount += 1
        guard let useCase = generateCreatePostboxUseCaseResult else {
            return super.generateCreatePostbox()
        }
        return useCase
    }

    // MARK: - StoreMessage

    var generateStoreMessageUseCaseCallCount = 0
    var generateStoreMessageUseCaseResult: MockStoreMessageUseCase?

    override func generateStoreMessage() -> StoreMessageUseCase {
        generateStoreMessageUseCaseCallCount += 1
        guard let useCase = generateStoreMessageUseCaseResult else {
            return super.generateStoreMessage()
        }
        return useCase
    }

    // MARK: - DeletePostbox

    var generateDeletePostboxUseCaseCallCount = 0
    var generateDeletePostboxUseCaseResult: MockDeletePostboxUseCase?

    override func generateDeletePostbox() -> DeletePostboxUseCase {
        generateDeletePostboxUseCaseCallCount += 1
        guard let useCase = generateDeletePostboxUseCaseResult else {
            return super.generateDeletePostbox()
        }
        return useCase
    }

    // MARK: - SubscribeToMessagesReceived

    var generateSubscribeToMessagesReceivedUseCaseCallCount = 0
    var generateSubscribeToMessagesReceivedUseCaseResult: MockSubscribeToMessagesReceivedUseCase?

    override func generateSubscribeToMessagesReceived() -> SubscribeToMessagesReceivedUseCase {
        generateSubscribeToMessagesReceivedUseCaseCallCount += 1
        guard let useCase = generateSubscribeToMessagesReceivedUseCaseResult else {
            return super.generateSubscribeToMessagesReceived()
        }
        return useCase
    }

    // MARK: - SubscribeToPostboxDeleted

    var generateSubscribeToPostboxDeletedUseCaseCallCount = 0
    var generateSubscribeToPostboxDeletedUseCaseResult: MockSubscribeToPostboxDeletedUseCase?

    override func generateSubscribeToPostboxDeleted() -> SubscribeToPostboxDeletedUseCase {
        generateSubscribeToPostboxDeletedUseCaseCallCount += 1
        guard let useCase = generateSubscribeToPostboxDeletedUseCaseResult else {
            return super.generateSubscribeToPostboxDeleted()
        }
        return useCase
    }

    // MARK: - GetPostboxEndpoint

    var generateGetPostboxEndpointUseCaseCallCount = 0
    var generateGetPostboxEndpointUseCaseResult: MockGetPostboxEndpointUseCase?

    override func generateGetPostboxEndpoint() -> GetPostboxEndpointUseCase {
        generateGetPostboxEndpointUseCaseCallCount += 1
        guard let useCase = generateGetPostboxEndpointUseCaseResult else {
            return super.generateGetPostboxEndpoint()
        }
        return useCase
    }
}

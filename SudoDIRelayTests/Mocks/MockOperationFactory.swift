//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

// swiftlint:disable force_cast

import SudoOperations
import AWSAppSync
import SudoLogging
@testable import SudoDIRelay

class MockOperationFactory: OperationFactory {

    var getMessagesOperation: MockQueryOperation<GetMessagesQuery>?

    var generateQueryLastProperties: (query: AnyObject, cachePolicy: SudoDIRelay.CachePolicy)?

    override func generateQueryOperation<Query>(
        query: Query,
        appSyncClient: AWSAppSyncClient,
        cachePolicy: SudoDIRelay.CachePolicy = .remoteOnly,
        logger: Logger
    ) -> PlatformQueryOperation<Query> where Query: GraphQLQuery {
        generateQueryLastProperties = (query, cachePolicy)
        switch query.self {
        case is GetMessagesQuery:
            guard let op = getMessagesOperation else {
                return super.generateQueryOperation(query: query, appSyncClient: appSyncClient, cachePolicy: cachePolicy, logger: logger)
            }
            return op as! PlatformQueryOperation<Query>
        default:
            return super.generateQueryOperation(query: query, appSyncClient: appSyncClient, cachePolicy: cachePolicy, logger: logger)
        }
    }

    var createPostboxOperation: MockMutationOperation<SendInitMutation>?
    var storeMessageOperation: MockMutationOperation<StoreMessageMutation>?
    var deletePostboxOperation: MockMutationOperation<DeletePostBoxMutation>?

    var generateMutationLastProperty: AnyObject?

    override func generateMutationOperation<Mutation>(
        mutation: Mutation,
        optimisticUpdate: OptimisticResponseBlock? = nil,
        optimisticCleanup: OptimisticCleanupBlock? = nil,
        appSyncClient: AWSAppSyncClient,
        logger: Logger
    ) -> PlatformMutationOperation<Mutation> where Mutation: GraphQLMutation {
        generateMutationLastProperty = mutation
        switch mutation.self {
        case is SendInitMutation:
            guard let op = createPostboxOperation else {
                return super.generateMutationOperation(
                    mutation: mutation,
                    optimisticUpdate: optimisticUpdate,
                    optimisticCleanup: optimisticCleanup,
                    appSyncClient: appSyncClient,
                    logger: logger
                )
            }
            return op as! PlatformMutationOperation<Mutation>
        case is StoreMessageMutation:
            guard let op = storeMessageOperation else {
                return super.generateMutationOperation(
                    mutation: mutation,
                    optimisticUpdate: optimisticUpdate,
                    optimisticCleanup: optimisticCleanup,
                    appSyncClient: appSyncClient,
                    logger: logger
                )
            }
            return op as! PlatformMutationOperation<Mutation>
        case is DeletePostBoxMutation:
            guard let op = deletePostboxOperation else {
                return super.generateMutationOperation(
                    mutation: mutation,
                    optimisticUpdate: optimisticUpdate,
                    optimisticCleanup: optimisticCleanup,
                    appSyncClient: appSyncClient,
                    logger: logger
                )
            }
            return op as! PlatformMutationOperation<Mutation>
        default:
            return super.generateMutationOperation(
                mutation: mutation,
                optimisticUpdate: optimisticUpdate,
                optimisticCleanup: optimisticCleanup,
                appSyncClient: appSyncClient,
                logger: logger
            )
        }
    }
}

class MockMutationOperation<Mutation: GraphQLMutation>: PlatformMutationOperation<Mutation> {

    var mockResult: Mutation.Data?
    override var result: Mutation.Data? {
        get {
            return mockResult
        }
        set {
            mockResult = newValue
        }
    }

    var error: Error?

    override func execute() {
        if let error = error {
            finishWithError(error)
        } else {
            finish()
        }
    }

}

class MockCreatePostboxOperation: MockMutationOperation<SendInitMutation> {

    init(error: Error? = nil, result: SendInitMutation.Data? = nil) {
        let appSyncClient = MockAWSAppSyncClientGenerator.generateClient()
        let input = WriteToRelayInput(
            messageId: "init",
            connectionId: "dummyId",
            cipherText: "",
            direction: Direction.inbound,
            utcTimestamp: "Thu, 1 Jan 1970 00:00:00 GMT+00"
        )
        let mutation = SendInitMutation(input: input)
        super.init(appSyncClient: appSyncClient, mutation: mutation, logger: .testLogger)
        self.error = error
        mockResult = result
    }
}

class MockStoreMessageOperation: MockMutationOperation<StoreMessageMutation> {

    init(error: Error? = nil, result: StoreMessageMutation.Data? = nil) {
        let appSyncClient = MockAWSAppSyncClientGenerator.generateClient()
        let input = WriteToRelayInput(
            messageId: "dummyId",
            connectionId: "dummyId",
            cipherText: "message",
            direction: Direction.inbound,
            utcTimestamp: "Thu, 1 Jan 1970 00:00:00 GMT+00"
        )
        let mutation = StoreMessageMutation(input: input)
        super.init(appSyncClient: appSyncClient, mutation: mutation, logger: .testLogger)
        self.error = error
        mockResult = result
    }
}

class MockDeletePostboxOperation: MockMutationOperation<DeletePostBoxMutation> {

    init(error: Error? = nil, result: DeletePostBoxMutation.Data? = nil) {
        let appSyncClient = MockAWSAppSyncClientGenerator.generateClient()
        let input = IdAsInput(id: "dummyId")
        let mutation = DeletePostBoxMutation(input: input)
        super.init(appSyncClient: appSyncClient, mutation: mutation, logger: .testLogger)
        self.error = error
        mockResult = result
    }
}

class MockQueryOperation<Query: GraphQLQuery>: PlatformQueryOperation<Query> {

    var mockResult: Query.Data?
    override var result: Query.Data? {
        get {
            return mockResult
        }
        set {
            mockResult = newValue
        }
    }

    var error: Error?

    override func execute() {
        if let error = error {
            finishWithError(error)
        } else {
            finish()
        }
    }

}

class MockGetMessagesOperation: MockQueryOperation<GetMessagesQuery> {

    init(error: Error? = nil, result: GetMessagesQuery.Data? = nil) {
        let appSyncClient = MockAWSAppSyncClientGenerator.generateClient()
        let input = IdAsInput(id: "dummyId")
        let query = GetMessagesQuery(input: input)
        super.init(appSyncClient: appSyncClient, query: query, cachePolicy: CachePolicy.remoteOnly, logger: .testLogger)
        self.error = error
        mockResult = result
    }
}

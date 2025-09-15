//
// Copyright © 2025 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Amplify
import Foundation
@testable import SudoApiClient

class MockSudoApiClient: SudoApiClient {

    var fetchCalled = false
    var fetchCallCount = 0
    var fetchParameters: (query: Any, Void)?
    var fetchParameterList: [(query: Any, Void)] = []
    var fetchResult: Result<Any, Error> = .failure(ApiOperationError.fatalError(description: "Not assigned"))
    var fetchResultList: [Result<Any, Error>] = []

    func fetch<Query>(query: Query) async throws -> Query.Data where Query: GraphQLQuery {
        fetchCalled = true
        fetchCallCount += 1
        fetchParameters = (query, ())
        fetchParameterList.append((query, ()))
        let result = fetchResultList.isEmpty ? fetchResult : fetchResultList.removeFirst()
        guard let data = try result.get() as? Query.Data else {
            throw ApiOperationError.fatalError(description: "Incorrect result type assigned")
        }
        return data
    }

    var performCalled = false
    var performCallCount = 0
    var performParameters: (mutation: Any, operationTimeout: Int?)?
    var performParameterList: [(mutation: Any, operationTimeout: Int?)] = []
    var performResult: Result<Any, Error> = .failure(ApiOperationError.fatalError(description: "Not assigned"))
    var performResultList: [Result<Any, Error>] = []

    func perform<Mutation>(
        mutation: Mutation,
        operationTimeout: Int? = nil
    ) async throws -> Mutation.Data where Mutation: GraphQLMutation {
        performCalled = true
        performCallCount += 1
        performParameters = (mutation, operationTimeout)
        performParameterList.append((mutation, operationTimeout))
        let result = performResultList.isEmpty ? performResult : performResultList.removeFirst()
        guard let data = try result.get() as? Mutation.Data else {
            throw ApiOperationError.fatalError(description: "Incorrect result type assigned")
        }
        return data
    }

    var subscribeCalled = false
    var subscribeCallCount = 0
    var subscribeParameters: (
        subscription: Any,
        queue: DispatchQueue,
        statusChangeHandler: ((GraphQLClientConnectionState) -> Void)?,
        completionHandler: ((Result<Void, Error>) -> Void)?,
        resultHandler: (Result<Any, Error>) -> Void
    )?
    var subscribeSubscription = GraphQLClientSubscriptionMock()

    func subscribe<Subscription: GraphQLSubscription>(
        subscription: Subscription,
        queue: DispatchQueue,
        statusChangeHandler: ((GraphQLClientConnectionState) -> Void)?,
        completionHandler: ((Result<Void, Error>) -> Void)?,
        resultHandler: @escaping (Result<Subscription.Data, Error>) -> Void
    ) -> GraphQLClientSubscription {
        subscribeCalled = true
        subscribeCallCount += 1
        let castResultHandler: (Result<Any, Error>) -> Void = {
            switch $0 {
            case .success(let value):
                if let data = value as? Subscription.Data {
                    resultHandler(.success(data))
                } else {
                    resultHandler(.failure(ApiOperationError.fatalError(description: "Incorrect data type")))
                }
            case .failure(let error):
                resultHandler(.failure(error))
            }
        }
        subscribeParameters = (
            subscription,
            queue,
            statusChangeHandler,
            completionHandler,
            castResultHandler
        )
        return subscribeSubscription
    }

    func getGraphQLClient() -> any GraphQLClient {
        fatalError("Not implemented")
    }
}

class GraphQLClientSubscriptionMock: GraphQLClientSubscription {

    var cancelCalled = false
    var cancelCallCount = 0

    func cancel() {
        cancelCalled = true
        cancelCallCount += 1
    }
}

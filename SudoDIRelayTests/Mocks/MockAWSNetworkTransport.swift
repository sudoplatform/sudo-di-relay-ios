//
// Copyright © 2023 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import AWSAppSync
import SudoLogging
import AWSCore
import SudoUser
import SudoApiClient

struct MockAWSAppSyncServiceConfigProvider: AWSAppSyncServiceConfigProvider {
    var endpoint = URL(string: "https://resource-id.appsync-api.us-west-2.amazonaws.com/graphql")!

    var region = AWSRegionType.USWest2

    var authType = AWSAppSyncAuthType.apiKey

    var apiKey: String? = "dummy-api-key"

    var clientDatabasePrefix: String? = "dummyClientDatabasePrefix"
}

class MockCancellable: Cancellable {
    var cancelCalls = 0
    func cancel() {
        cancelCalls += 1
    }
}

class MockAWSNetworkTransport: AWSNetworkTransport {

    typealias SubscriptionCompletion = (JSONObject?, Error?) -> Void

    var data = Data()
    var jsonObject: JSONObject?
    var error: Error?
    var responseBody: [JSONObject] = []
    var variables: GraphQLMap?

    var cancellable = MockCancellable()

    // Mutation
    func send(data: Data, completionHandler: ((JSONObject?, Error?) -> Void)?) {
        self.data = data
        completionHandler?(self.jsonObject, self.error)
    }

    func sendSubscriptionRequest<Operation: GraphQLOperation>(
        operation: Operation,
        completionHandler: @escaping SubscriptionCompletion
    ) throws -> Cancellable {
        completionHandler(self.jsonObject, self.error)
        return cancellable
    }

    func send<Operation: GraphQLOperation>(
        operation: Operation,
        completionHandler: @escaping (GraphQLResponse<Operation>?, Error?) -> Void
    ) -> Cancellable {
        self.variables = operation.variables
        var response: GraphQLResponse<Operation>?
        if !self.responseBody.isEmpty {
            let responseBody = self.responseBody.removeFirst()
            response = GraphQLResponse(operation: operation, body: responseBody)
        }
        completionHandler(response, self.error)
        return cancellable
    }

}

class MockBlockingAWSNetworkTransport: MockAWSNetworkTransport {
    override func send(data: Data, completionHandler: ((JSONObject?, Error?) -> Void)?) {
        // No Op.
    }

    override func sendSubscriptionRequest<Operation: GraphQLOperation>(
        operation: Operation,
        completionHandler: @escaping (JSONObject?, Error?) -> Void
    ) throws -> Cancellable {
        return MockCancellable()
    }

    override func send<Operation: GraphQLOperation>(
        operation: Operation,
        completionHandler: @escaping (GraphQLResponse<Operation>?, Error?) -> Void
    ) -> Cancellable {
        return MockCancellable()
    }

}

struct MockAWSAppSyncClientGenerator {
    typealias Result = (client: SudoApiClient, transport: MockAWSNetworkTransport)
    static func generate(logger: Logger, sudoUserClient: SudoUserClient, transport: MockAWSNetworkTransport = MockAWSNetworkTransport()) throws -> Self.Result {
        let mockProvider = MockAWSAppSyncServiceConfigProvider()
        let appSyncConfig = AWSAppSyncClientConfiguration(appSyncServiceConfig: mockProvider, networkTransport: transport)
        let appSyncClient = try AWSAppSyncClient(appSyncConfig: appSyncConfig)
        let sudoApiClient = try SudoApiClient(configProvider: mockProvider, sudoUserClient: sudoUserClient, appSyncClient: appSyncClient)
        return (sudoApiClient, transport)
    }
}

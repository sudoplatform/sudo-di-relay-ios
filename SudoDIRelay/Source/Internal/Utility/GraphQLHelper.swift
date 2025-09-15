//
// Copyright © 2023 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation
import SudoApiClient


struct GraphQLHelper {

    static func performMutation<Mutation: GraphQLMutation>(
        graphQLClient: SudoApiClient,
        mutation: Mutation
    ) async throws -> Mutation.Data {
        do {
            return try await graphQLClient.perform(mutation: mutation)
        } catch {
            throw SudoDIRelayError.fromApiOperationError(error: error)
        }
    }

    static func performQuery<Query: GraphQLQuery>(
        graphQLClient: SudoApiClient,
        query: Query
    ) async throws -> Query.Data {
        do {
            return try await graphQLClient.fetch(query: query)
        } catch {
            throw SudoDIRelayError.fromApiOperationError(error: error)
        }
    }
}

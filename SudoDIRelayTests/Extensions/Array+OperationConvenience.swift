//
// Copyright © 2020 Anonyome Labs, Inc. All rights reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

extension Array where Element: Operation {

    func contains<T: Operation>(operationType: T.Type) -> Bool {
        return self.contains(where: { $0 is T })
    }

    func first<T: Operation>(whereType: T.Type) -> T? {
        return self.first(where: { $0 is T }) as? T
    }
}

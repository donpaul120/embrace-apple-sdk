//
//  Copyright © 2023 Embrace Mobile, Inc. All rights reserved.
//

import Foundation
import OpenTelemetryApi
import OpenTelemetrySdk

@testable import EmbraceOTelInternal

class DummyEmbraceLogShared: EmbraceLogSharedState {
    var processors: [LogRecordProcessor] = []
    var config: any EmbraceLoggerConfig = RandomConfig()
    var resourceProvider: EmbraceResourceProvider
    var spanContextProvider: (() -> SpanContext?)?

    init(resourceProvider: EmbraceResourceProvider = DummyEmbraceResourceProvider()) {
        self.resourceProvider = resourceProvider
    }

    func update(_ config: any EmbraceLoggerConfig) {}
}

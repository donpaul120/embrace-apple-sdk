//
//  Copyright © 2023 Embrace Mobile, Inc. All rights reserved.
//

import Foundation
import OpenTelemetryApi
import OpenTelemetrySdk

@testable import EmbraceOTelInternal

class MockEmbraceLogSharedState: EmbraceLogSharedState {
    var processors: [LogRecordProcessor]
    var config: any EmbraceLoggerConfig
    var resourceProvider: EmbraceResourceProvider
    var spanContextProvider: (() -> SpanContext?)?

    init(
        processors: [LogRecordProcessor] = [],
        config: any EmbraceLoggerConfig = RandomConfig(),
        resourceProvider: EmbraceResourceProvider = DummyEmbraceResourceProvider()
    ) {
        self.processors = processors
        self.config = config
        self.resourceProvider = resourceProvider
    }

    func update(_ config: any EmbraceLoggerConfig) {
        self.config = config
    }
}

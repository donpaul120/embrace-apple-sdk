//
//  Copyright © 2024 Embrace Mobile, Inc. All rights reserved.
//

import Foundation
import OpenTelemetryApi
import OpenTelemetrySdk

public protocol EmbraceLogSharedState {
    var processors: [LogRecordProcessor] { get }
    var config: any EmbraceLoggerConfig { get }
    var resourceProvider: EmbraceResourceProvider { get }

    /// Supplies the active session span context to stamp onto log records.
    /// Used so Signoz can link logs to traces when no explicit span context is provided.
    var spanContextProvider: (() -> SpanContext?)? { get set }

    func update(_ config: any EmbraceLoggerConfig)
}


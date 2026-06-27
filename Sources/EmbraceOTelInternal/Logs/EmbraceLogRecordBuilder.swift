//
//  Copyright © 2024 Embrace Mobile, Inc. All rights reserved.
//

import Foundation
import OpenTelemetryApi
import OpenTelemetrySdk

class EmbraceLogRecordBuilder: EventBuilder {

    let sharedState: EmbraceLogSharedState
    let instrumentationScope: InstrumentationScopeInfo

    private(set) var timestamp: Date?
    private(set) var observedTimestamp: Date?
    private(set) var severity: Severity?
    private(set) var spanContext: SpanContext?
    private(set) var body: AttributeValue?
    private(set) var attributes: [String: AttributeValue]

    init(sharedState: EmbraceLogSharedState, attributes: [String: AttributeValue]) {
        self.sharedState = sharedState
        self.attributes = attributes
        self.instrumentationScope = .init(name: "EmbraceLogger")
    }

    func setTimestamp(_ timestamp: Date) -> Self {
        self.timestamp = timestamp
        return self
    }

    func setObservedTimestamp(_ observed: Date) -> Self {
        self.observedTimestamp = observed
        return self
    }

    func setSpanContext(_ context: SpanContext) -> Self {
        self.spanContext = context
        return self
    }

    func setSeverity(_ severity: Severity) -> Self {
        self.severity = severity
        return self
    }

    func setBody(_ body: AttributeValue) -> Self {
        self.body = body
        return self
    }

    func setAttributes(_ attributes: [String: AttributeValue]) -> Self {
        attributes.forEach {
            self.attributes[$0.key] = $0.value
        }
        return self
    }

    func setData(_ attributes: [String: OpenTelemetryApi.AttributeValue]) -> Self {
        return setAttributes(attributes)
    }

    func emit() {
        let resource = sharedState.resourceProvider.getResource()

        if spanContext == nil {
            // Caller-supplied context wins; fall back to the active OTel span, then to the session span
            // so log records carry trace_id/span_id for Signoz log-to-trace correlation.
            spanContext = OpenTelemetry.instance.contextProvider.activeSpan?.context
                ?? sharedState.spanContextProvider?()
        }

        sharedState.processors.forEach {
            let now = Date()
            let log = ReadableLogRecord(
                resource: resource,
                instrumentationScopeInfo: instrumentationScope,
                timestamp: timestamp ?? now,
                observedTimestamp: observedTimestamp ?? now,
                spanContext: spanContext,
                severity: severity,
                body: body,
                attributes: attributes)
            $0.onEmit(logRecord: log)
        }
    }
}

import ReactiveSwift

private let scheduler = QueueScheduler(
    qos: .background,
    name: "com.example.api",
    targeting: nil
)

extension URLSession {

    func rac_dataResponse(_ request: URLRequest) -> SignalProducer<Data, ErrorEnvelope> {

        let producer = reactive.data(with: request)

        print("⚪️ [Api] Starting request \(self.sanitized(request))")

        return producer
            .start(on: scheduler)
            .flatMapError { _ in SignalProducer(error: .couldNotParseErrorEnvelopeJSON) }
            .flatMap { (data, response) -> SignalProducer<Data, ErrorEnvelope> in
                guard let res = response as? HTTPURLResponse else {
                    fatalError()
                }
                guard (200..<300).contains(res.statusCode),
                    let headers = res.allHeaderFields as? [String: String],
                    let contentType = headers["Content-Type"], contentType.hasPrefix("application/json") else {

                        do {
                            let error = try Constant.jsonDecoder.decode(ErrorEnvelope.self, from: data)
                            print("🔴 [Api] Failure \(self.sanitized(request)) \n Error - \(error)")

                            return .init(error: error)
                        } catch {
                            print("🔴 [Api] Failure \(self.sanitized(request)) \n decoding error - \(error)")
                            return .init(error: .couldNotDecodeJSON(error))
                        }
                }

//                print("json response: \(String(data: data, encoding: .utf8))")

                if let errorResult = try? Constant.jsonDecoder.decode(ErrorEnvelopeResult.self, from: data) {
                    let error = errorResult.error
                    print("🔴 [Api] Failure \(self.sanitized(request)) \n Error - \(error)")
                    return .init(error: error)
                }

                print("🔵 [Api] Success \(self.sanitized(request))")
                return .init(value: data)
        }
    }

    // MARK: - Private

    // swiftlint:disable force_try
    private static let sanitationRules = [
        "access_token=[REDACTED]":
            try! NSRegularExpression(pattern: "access_token=([a-zA-Z0-9]*)", options: .caseInsensitive)
    ]

    private func sanitized(_ request: URLRequest) -> String {
        guard let urlString = request.url?.absoluteString else {
            return ""
        }

        return URLSession.sanitationRules.reduce(urlString) { accum, templateAndRule in
            let (template, rule) = templateAndRule
            let range = NSRange(location: 0, length: accum.count)
            return rule.stringByReplacingMatches(
                in: accum,
                options: .withTransparentBounds,
                range: range,
                withTemplate: template
            )
        }
    }
}

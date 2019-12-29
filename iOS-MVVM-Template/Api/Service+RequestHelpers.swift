import ReactiveSwift

extension Service {
    private static let session = URLSession(configuration: .default)

    func request<T: Codable>(_ route: Route) -> SignalProducer<T, ErrorEnvelope> {
        let properties = route.requestProperties
        let url = serverConfig.apiBaseUrl
            .appendingPathComponent(properties.path)
        let request = preparedRequest(
            forURL: url,
            method: properties.method,
            query: properties.query
        )
        return Service.session.rac_dataResponse(request)
            .flatMap(decodeModel)
    }

    // MARK: - Private

    private func decodeModel<T: Codable>(data: Data) -> SignalProducer<T, ErrorEnvelope> {
        return SignalProducer(value: data)
            .flatMap { (data) -> SignalProducer<T, ErrorEnvelope> in
                do {
                    let model = try Constant.jsonDecoder.decode(T.self, from: data)
                    return .init(value: model)
                } catch {
                    return .init(error: .couldNotDecodeJSON(error))
                }
        }
    }
}

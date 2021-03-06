import Alamofire



extension DataRequest {
    
    @discardableResult
    public func leo_validateResponse() -> Self {
        return self.validate { (request, response, data) -> Request.ValidationResult in
            
            guard let jsonData = data, let jsonString = String(data: jsonData, encoding: .utf8) else {
                return .failure(NetworkLayerError.badResponse(message: "Response is nil or cant convert to utf8 string"))
            }
            
            do {
                let baseResponse = try LEOBaseResponse(JSONString: jsonString)
                let code = baseResponse.code
                guard code == .success else {
                    return .failure(NetworkLayerError.businessProblem(code: code, errors: baseResponse.errors))
                }
                return .success
            } catch {
                return .failure(NetworkLayerError.badResponse(message: error.localizedDescription))
            }
        }
    }
}


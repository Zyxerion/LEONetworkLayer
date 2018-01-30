import ObjectMapper


public enum LEOApiGlobalErrorCode: String {
    case success = "success"
    case businessConflict = "business_conflict"
    case unprocessableEntity = "unprocessable_entity"
    case badParameters = "bad_parameters"
    case internalError = "internal_error"
    case notFound = "not_found"
    case securityError = "security_error"
    case permissionError = "permission_error"
    case unknown = "Unknown"
}



open class LEOBaseResponse: ImmutableMappable {
    
    let code: LEOApiGlobalErrorCode
    let message: String?
    let errors: [LEOError]?
    
    
    required public init(map: Map) throws {
        code = try map.value("code", using: EnumTransform<LEOApiGlobalErrorCode>())
        message = try? map.value("message")
        errors = try? map.value("errors")
    }
    
    
}

extension LEOBaseResponse {
    func getNetworkError() -> LEONetworkLayerError {
        return .businessProblem(code: self.code, errors: errors)
    }
    
    var isSuccess: Bool {
        if self.code == .success {
            return true
        }
        return false
    }
}

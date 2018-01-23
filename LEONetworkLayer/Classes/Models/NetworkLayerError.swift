enum NetworkLayerError: Error {
    
    enum ConnectionFailReasons {
        case noConnection
        case unknown
    }
    
    case unknown
    case connectionFail(reason: ConnectionFailReasons)
    case businessProblem(code: LEOApiErrorCode, errors:[LEOError]?)
}
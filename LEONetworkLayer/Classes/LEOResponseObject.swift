import Alamofire
import AlamofireObjectMapper
import ObjectMapper



public enum Response<T> {
    case success(T)
    case error(Error)
}



extension DataRequest {
    
    @discardableResult
    public func responseLEO<T: LEOBaseResponse>(completionHandler leoCompletionHandler: @escaping (Response<T>) -> Void) -> Self {
        
        return self.responseJSON { (data: DataResponse<Any>) in
            switch data.result {
                
            case .success(let rawJson):
                do {
                    let parsed: T = try self.map(data: rawJson)
                    leoCompletionHandler(.success(parsed))
                    
                } catch {
                    leoCompletionHandler(.error(error))
                }
                
                
            case .failure(let error):
                let leoError = self.getLeoError(error)
                leoCompletionHandler(.error(leoError))
            }
        }
    }
    
    
    private func map<T: LEOBaseResponse>(data: Any) throws -> T {
        guard let json = data as? [String: Any] else {
            throw LEONetworkLayerError.badResponse(message: "Data is not an dictionary, but: \(type(of: data))")
        }
        
        let map = Map(mappingType: .fromJSON, JSON: json)
        let result = try T(map: map)
        return result
    }
    
    
    private func getLeoError(_ error: Error) -> LEONetworkLayerError {
        if error is LEONetworkLayerError {
            return error as! LEONetworkLayerError
        } else {
            let error = error as NSError
            guard error.domain == NSURLErrorDomain else {
                return LEONetworkLayerError.unknown
            }
            
            switch error.code {
            case NSURLErrorBadURL,
                 NSURLErrorTimedOut,
                 NSURLErrorUnsupportedURL,
                 NSURLErrorCannotFindHost,
                 NSURLErrorCannotConnectToHost,
                 NSURLErrorNetworkConnectionLost,
                 NSURLErrorDNSLookupFailed,
                 NSURLErrorHTTPTooManyRedirects,
                 NSURLErrorResourceUnavailable,
                 NSURLErrorNotConnectedToInternet,
                 NSURLErrorRedirectToNonExistentLocation:
                return LEONetworkLayerError.connectionFail(reason: .noConnection)
                
            default:
                return LEONetworkLayerError.unknown
            }
        }
        
    }
    
    
}


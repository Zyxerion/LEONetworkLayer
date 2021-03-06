import RxSwift
import LEONetworkLayer



protocol CollectionService {
    
    func items() -> Single<[CollectionItem]>
    func items(_ params: PageParameters) -> Single<([CollectionItem], Pages)>
    func items(_ params: CursorParameters) -> Single<([CollectionItem], Cursors)>
}



class CollectionServiceImpl: CollectionService, RxRequestService {
    
    
    private enum Error: ErrorObjectProvider {
        case method(String, Swift.Error)
        
        var object: Swift.Error {
            let result = ErrorObject(domain: "CollectionService")
            
            switch self {
            case let .method(name, error):
                result.desc = "\"\(name)\" action failed"
                result.underlyingError = error
            }
            return result
        }
    }
    
    
    
    //MARK: - Properties
    let apiProvider: LEOProvider
    
    
    
    //MARK: - Lifecycle
    init(apiProvider: LEOProvider) {
        self.apiProvider = apiProvider
        
    }
    
    
    
    //MARK: - Interface
    func items() -> Single<[CollectionItem]> {
        let router = CollectionRouter.items
        return self.createObserver(type: LEOArrayResponse<CollectionItemDTO>.self, router: router)
            .map {
                $0.data.map { CollectionItem(dto: $0) }
            }
            .catchError {
                Observable.error(Error.method("Items", $0).object)
            }
            .asSingle()
    }
    
    
    func items(_ params: PageParameters) -> Single<([CollectionItem], Pages)> {
        let router = CollectionRouter.itemsPage(params)
        return self.createObserver(type: LEOArrayResponse<CollectionItemDTO>.self, router: router)
            .map {
                ($0.data.map { CollectionItem(dto: $0) },
                 Pages())
            }
            .catchError {
                Observable.error(Error.method("Items by Page", $0).object)
            }
            .asSingle()
    }
    
    
    func items(_ params: CursorParameters) -> Single<([CollectionItem], Cursors)> {
        let router = CollectionRouter.itemsCursor(params)
        return self.createObserver(type: LEOListResponse<CollectionItemDTO>.self, router: router)
            .map {
                ($0.data.map { CollectionItem(dto: $0) },
                 Cursors(previous: $0.prevCursor, next: $0.nextCursor))
            }
            .catchError {
                Observable.error(Error.method("Items by Cursor", $0).object)
            }
            .asSingle()
    }

}


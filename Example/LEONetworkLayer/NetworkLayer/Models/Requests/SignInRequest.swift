import ObjectMapper

class SignInRequest: Mappable {
    
    var login: String?
    var password: String?
    var platform: String = "ios"
    var deviceId: String?
    var versionApp: String?
    var pushDeviceId: String?
    
    init() {}
    
    init(login: String?, password: String?) {
        self.login = login
        self.password = password
    }
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        login <- map["login"]
        password <- map["password"]
        platform <- map["meta.platform"]
        deviceId <- map["meta.deviceId"]
        versionApp <- map["meta.versionApp"]
        pushDeviceId <- map["meta.pushDeviceId"]
    }
}

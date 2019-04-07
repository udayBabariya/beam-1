import Foundation
import RealmSwift

final class RealmAPI {
    static let shared = RealmAPI()
    let realm: Realm;
    
    private init() {
        let fileManager = FileManager.default
        let directory = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.com.passshare.pass-share")!
        let realmPath = directory.appendingPathComponent("db.realm")
        Realm.Configuration.defaultConfiguration = Realm.Configuration(fileURL: realmPath)
        realm = try! Realm()
    }
    
    func write(data: Object) {
        try! realm.write {
            realm.add(data)
        }
    }
    
    func read(filterBy identifier: String) -> Credential {
        return realm.objects(Credential.self).filter("identifier = '\(identifier)'").first!
    }
}
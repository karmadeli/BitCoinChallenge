//
//  RealmCRUDService.swift
//  BitCoinChallenge
//
//  Created by Chad Murdock on 5/26/19.
//  Copyright © 2019 KarmaDeli Works. All rights reserved.
//

import Foundation
import RealmSwift


/// Handles the saving and deleting of object from Realm.
class RealmCRUDService {
    static let shared = RealmCRUDService()
    var realm: Realm? {
        do{
            return try Realm()
        }
        catch{
            print(error)
            return nil
        }
    }
    
    func delete<T: Object>(realmObject : T){
        do{
            try realm?.write {
                if let city = realmObject as? UserSavedCities{
                    guard let results = realm?.objects(UserSavedCities.self).filter(NSPredicate(format: "name = %@", city.name)) else { return }
                    realm?.delete(results)
                }
            }
        }
        catch{
            //error
            print(error, "error in create")
        }
    }

    func create<T: Object>(realmObject : T) {
        do{
            try realm?.write {
                realm?.add(realmObject)
            }
        }
        catch{
            //error
            print(error, "error in create")
        }
        
    }

}

//
//  File.swift
//  
//
//  Created by Dicoding Reviewer on 07/09/21.
//

import Foundation
import Combine
import RealmSwift
import CoreModule

public struct GetGamesLocaleDataSource: LocaleDataSource {

    public typealias Request = Int
    
    public typealias Response = GameEntity
    
    private let _realm: Realm
    
    public init(realm: Realm) {
        _realm = realm
    }
    
    public func list(request: Int?) -> AnyPublisher<[GameEntity], Error> {
        return Future<[GameEntity], Error> { completion in
            let games: Results<GameEntity> = {
                _realm.objects(GameEntity.self)
            }()
            completion(.success(games.toArray(ofType: GameEntity.self)))
            
        }.eraseToAnyPublisher()
    }
    
    public func add(entities: [GameEntity]) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            do {
                try _realm.write {
                    for game in entities {
                        _realm.add(game, update: .all)
                    }
                    completion(.success(true))
                }
            } catch {
                completion(.failure(DatabaseError.requestFailed))
            }
            
        }.eraseToAnyPublisher()
    }
    
    public func get(id: Int) -> AnyPublisher<GameEntity, Error> {
        return Future<GameEntity, Error> { completion in
            
            let meals: Results<GameEntity> = {
                _realm.objects(GameEntity.self)
                    .filter("id = \(id)")
            }()
            
            guard let meal = meals.first else {
                completion(.failure(DatabaseError.requestFailed))
                return
            }
            
            completion(.success(meal))
            
        }.eraseToAnyPublisher()
    }
    
    public func update(id: Int, entity: GameEntity) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { completion in
            if let mealEntity = {
                _realm.objects(GameEntity.self).filter("id = \(id)")
            }().first {
                do {
                    try _realm.write {
                        mealEntity.setValue(entity.desc, forKey: "desc")
                        mealEntity.setValue(entity.genres, forKey: "genres")
                        mealEntity.setValue(entity.image, forKey: "image")
                        mealEntity.setValue(entity.name, forKey: "name")
                        mealEntity.setValue(entity.rating, forKey: "rating")
                        mealEntity.setValue(entity.favorite, forKey: "favorite")
                        mealEntity.setValue(entity.releaseDate, forKey: "releaseDate")
                    }
                    completion(.success(true))
                    
                } catch {
                    completion(.failure(DatabaseError.requestFailed))
                }
            } else {
                completion(.failure(DatabaseError.invalidInstance))
            }
        }.eraseToAnyPublisher()
    }
    
}

//
//  File.swift
//  
//
//  Created by Dicoding Reviewer on 07/09/21.
//

import CoreModule

public struct GameMapper: Mapper {
    
    public typealias Request = Int
    public typealias Response = GameResponse
    public typealias Entity = GameEntity
    public typealias Domain = GameModel
    
    public init() {}
    
    public func transformResponseToEntity(request: Int?, response: GameResponse) -> GameEntity {
        let game = GameEntity()
        game.id = response.id ?? 0
        game.name = response.name ?? "null"
        game.desc = response.description ?? "null"
        game.image = response.backgroundImage ?? "null"
        game.rating = response.rating ?? 0.0
        game.releaseDate = response.released ?? "null"
        game.genres = response.genres.map { $0.name ?? "null" }.joined(separator: ",")
        return game
    }
    
    public func transformEntityToDomain(entity: GameEntity) -> GameModel {
        let genres = entity.genres.split(separator: ",").map {
             GenreModel(id: $0.startIndex, name: String($0))
        }
        return GameModel(
            id: entity.id,
            name: entity.name,
            released: entity.releaseDate,
            description: entity.desc,
            backgroundImage: entity.image,
            rating: entity.rating,
            genres: genres,
            favorite: entity.favorite
        )
    }
}

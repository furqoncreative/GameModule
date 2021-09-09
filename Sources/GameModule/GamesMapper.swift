//
//  File.swift
//
//
//  Created by Dicoding Reviewer on 07/09/21.
//

import CoreModule

public struct GamesMapper: Mapper {
    public typealias Request = Int
    public typealias Response = [GameResponse]
    public typealias Entity = [GameEntity]
    public typealias Domain = [GameModel]
    
    public init() {}
    
    public func transformResponseToEntity(request: Int?, response: [GameResponse]) -> [GameEntity] {
        return response.map { result in
            let newGame = GameEntity()
            newGame.id = result.id ?? 0
            newGame.name = result.name ?? "null"
            newGame.desc = result.description ?? "null"
            newGame.image = result.backgroundImage ?? "null"
            newGame.rating = result.rating ?? 0.0
            newGame.releaseDate = result.released ?? "null"
            newGame.genres = result.genres.map { $0.name ?? "null" }.joined(separator: ",")
            return newGame
        }
    }
    
    public func transformEntityToDomain(entity: [GameEntity]) -> [GameModel] {
        return entity.map { result in
            let genres = result.genres.split(separator: ",").map {
                return GenreModel(id: $0.startIndex, name: String($0))
            }
            return GameModel(
                id: result.id,
                name: result.name,
                released: result.releaseDate,
                description: result.desc,
                backgroundImage: result.image,
                rating: result.rating,
                genres: genres,
                favorite: result.favorite
            )
        }
    }
}

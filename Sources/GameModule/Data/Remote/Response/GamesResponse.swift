//
//  ListGame.swift
//  Game Center
//
//  Created by Dicoding Reviewer on 16/08/21.
//

import Foundation

// MARK: - Games
public struct GamesResponse: Decodable {
    let results: [GameResponse]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}

// MARK: - Game
public struct GameResponse: Decodable, Identifiable {
    public let id: Int?
    let name, released, description: String?
    let backgroundImage: String?
    let rating: Double?
    let genres: [Genre]

    enum CodingKeys: String, CodingKey {
        case id, name, released, rating, genres
        case backgroundImage = "background_image"
        case description = "description_raw"
    }
}

// MARK: - Genre
public struct Genre: Decodable, Identifiable {
    public let id: Int?
    let name: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}

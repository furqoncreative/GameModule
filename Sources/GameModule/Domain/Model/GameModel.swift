//
//  GameModel.swift
//  GameCenter
//
//  Created by Dicoding Reviewer on 31/08/21.
//

import Foundation

public struct GameModel: Equatable, Identifiable {
    public let id: Int
    public var name: String = ""
    public var released: String = ""
    public var description: String = ""
    public var backgroundImage: String = ""
    public var rating: Double? = 0.0
    public var genres: [GenreModel] = []
    public var favorite: Bool = false
}

public struct GenreModel: Equatable, Identifiable {
    public let id: Int?
    public let name: String?
}

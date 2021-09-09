//
//  File.swift
//  
//
//  Created by Dicoding Reviewer on 07/09/21.
//

import CoreModule
import Combine

public struct GetGamesRepository<
    GamesLocaleDataSource: LocaleDataSource,
    GamesRemoteDataSource: DataSource,
    Transformer: Mapper>: Repository
where
    GamesLocaleDataSource.Response == GameEntity,
    GamesRemoteDataSource.Response == [GameResponse],
    Transformer.Response == [GameResponse],
    Transformer.Entity == [GameEntity],
    Transformer.Domain == [GameModel] {
  
    public typealias Request = Int
    public typealias Response = [GameModel]
    
    private let _localeDataSource: GamesLocaleDataSource
    private let _remoteDataSource: GamesRemoteDataSource
    private let _mapper: Transformer
    
    public init(
        localeDataSource: GamesLocaleDataSource,
        remoteDataSource: GamesRemoteDataSource,
        mapper: Transformer) {
        
        _localeDataSource = localeDataSource
        _remoteDataSource = remoteDataSource
        _mapper = mapper
    }
    
    public func execute(request: Int?) -> AnyPublisher<[GameModel], Error> {
        return _localeDataSource.list(request: nil)
          .flatMap { result -> AnyPublisher<[GameModel], Error> in
            if result.isEmpty {
              return _remoteDataSource.execute(request: nil)
                .map { _mapper.transformResponseToEntity(request: nil, response: $0) }
                .catch { _ in _localeDataSource.list(request: nil) }
                .flatMap { _localeDataSource.add(entities: $0) }
                .filter { $0 }
                .flatMap { _ in _localeDataSource.list(request: nil)
                  .map { _mapper.transformEntityToDomain(entity: $0) }
                }
                .eraseToAnyPublisher()
            } else {
              return _localeDataSource.list(request: nil)
                .map { _mapper.transformEntityToDomain(entity: $0) }
                .eraseToAnyPublisher()
            }
          }.eraseToAnyPublisher()
    }
}

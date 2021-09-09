//
//  File.swift
//  
//
//  Created by Dicoding Reviewer on 07/09/21.
//

import CoreModule
import Combine

public struct GetGameRepository<
    GameLocaleDataSource: LocaleDataSource,
    RemoteDataSource: DataSource,
    Transformer: Mapper>: Repository
where
    GameLocaleDataSource.Request == Int,
    GameLocaleDataSource.Response == GameEntity,
    RemoteDataSource.Request == Int,
    RemoteDataSource.Response == GameResponse,
    Transformer.Request == Int,
    Transformer.Response == GameResponse,
    Transformer.Entity == GameEntity,
    Transformer.Domain == GameModel {
    
    public typealias Request = Int
    public typealias Response = GameModel
    
    private let _localeDataSource: GameLocaleDataSource
    private let _remoteDataSource: RemoteDataSource
    private let _mapper: Transformer
    
    public init(
        localeDataSource: GameLocaleDataSource,
        remoteDataSource: RemoteDataSource,
        mapper: Transformer) {
        
        _localeDataSource = localeDataSource
        _remoteDataSource = remoteDataSource
        _mapper = mapper
    }
    
    public func execute(request: Int?) -> AnyPublisher<GameModel, Error> {
        guard let request = request else { fatalError("Request cannot be empty") }
        return _localeDataSource.get(id: request)
          .flatMap { result -> AnyPublisher<GameModel, Error> in
            if result.desc == "null" {
                return _remoteDataSource.execute(request: request)
                    .map { _mapper.transformResponseToEntity(request: request, response: $0) }
                    .catch { _ in _localeDataSource.get(id: request) }
                    .flatMap { _localeDataSource.update(id: request, entity: $0) }
                .filter { $0 }
                    .flatMap { _ in _localeDataSource.get(id: request)
                        .map { _mapper.transformEntityToDomain(entity: $0) }
                }.eraseToAnyPublisher()
            } else {
                return _localeDataSource.get(id: request)
                    .map { _mapper.transformEntityToDomain(entity: $0) }
                .eraseToAnyPublisher()
            }
          }.eraseToAnyPublisher()
    }
}

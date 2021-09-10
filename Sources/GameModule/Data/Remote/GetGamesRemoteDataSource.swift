//
//  File.swift
//  
//
//  Created by Dicoding Reviewer on 07/09/21.
//

import CoreModule
import Combine
import Alamofire
import Foundation

public struct GetGamesRemoteDataSource: DataSource {
    public typealias Request = Int
    
    public typealias Response = [GameResponse]
    
    private let _endpoint: String
    
    public init(endpoint: String) {
        _endpoint = endpoint
    }
    
    public func execute(request: Int?) -> AnyPublisher<[GameResponse], Error> {
        return Future<[GameResponse], Error> { completion in
          if let url = URL(string: _endpoint) {
            AF.request(url)
              .validate()
              .responseDecodable(of: GamesResponse.self) { response in
                switch response.result {
                case .success(let value):
                    completion(.success(value.results))
                case .failure:
                  completion(.failure(URLError.invalidResponse))
                }
              }
          }
        }.eraseToAnyPublisher()
    }
}

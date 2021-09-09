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

public struct GetGameRemoteDataSource: DataSource {
    
    public typealias Request = Int
    
    public typealias Response = GameResponse
    
    private let _endpoint: String
    
    private let _apiKey: String
    
    public init(endpoint: String, apiKey: String) {
        _endpoint = endpoint
        _apiKey = apiKey
    }
    
    public func execute(request: Request?) -> AnyPublisher<Response, Error> {
        
        return Future<GameResponse, Error> { completion in
            
            guard let request = request else { return completion(.failure(URLError.invalidRequest) )}
            
            if let url = URL(string: "\(_endpoint)\(request)?key=\(_apiKey)") {
                print("game \(url)")
                AF.request(url)
                    .validate()
                    .responseDecodable(of: GameResponse.self) { response in
                        switch response.result {
                        case .success(let value):
                            print(value)
                            completion(.success(value))
                        case .failure:
                            completion(.failure(URLError.invalidResponse))
                        }
                    }
            }
        }.eraseToAnyPublisher()
    }
}

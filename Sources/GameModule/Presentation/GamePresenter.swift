//
//  File.swift
//  
//
//  Created by Dicoding Reviewer on 07/09/21.
//

import Foundation
import Combine
import CoreModule

public class GamePresenter<GameUseCase: UseCase, FavoriteUseCase: UseCase>: ObservableObject
where
    GameUseCase.Request == Int, GameUseCase.Response == GameModel,
    FavoriteUseCase.Request == Int, FavoriteUseCase.Response == GameModel {
    
    private var cancellables: Set<AnyCancellable> = []
    
    private let _gameUseCase: GameUseCase
    private let _favoriteUseCase: FavoriteUseCase
    
    @Published public var item: GameModel? = nil
    @Published public var errorMessage: String = ""
    @Published public var isLoading: Bool = false
    @Published public var isError: Bool = false
    
    public init(gameUseCase: GameUseCase, favoriteUseCase: FavoriteUseCase) {
        _gameUseCase = gameUseCase
        _favoriteUseCase = favoriteUseCase
    }
    
    public func getGame(request: GameUseCase.Request) {
        isLoading = true
        _gameUseCase.execute(request: request)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isError = true
                    self.isLoading = false
                case .finished:
                    self.isLoading = false
                }
            }, receiveValue: { item in
                self.item = item
            })
            .store(in: &cancellables)
    }
    
    public func updateFavoriteGame(request: FavoriteUseCase.Request) {
        _favoriteUseCase.execute(request: request)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure:
                    self.errorMessage = String(describing: completion)
                case .finished:
                    self.isLoading = false
                }
            }, receiveValue: { item in
                self.item = item
            })
            .store(in: &cancellables)
    }
    
}

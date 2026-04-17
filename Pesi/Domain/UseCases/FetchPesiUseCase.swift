//
//  FetchPesiUseCase.swift
//  Pesi
//
//  Created by Michele Manniello on 09/04/26.
//

import Foundation

final class FetchPesiUseCase  {
    let repository: PesoRepositoryInterface
    
    init(repository: PesoRepositoryInterface) {
        self.repository = repository
    }
    
    func execute() throws -> [PesoModel] {
       try repository.fetchData()
    }
}

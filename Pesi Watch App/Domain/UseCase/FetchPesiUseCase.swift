//
//  FetchPesiUseCase.swift
//  Pesi Watch App
//
//  Created by Michele Manniello on 13/04/26.
//

import Foundation

class FetchPesiUseCase  {
    let repository: PesoRepositoryInterface
    
    init(repository: PesoRepositoryInterface) {
        self.repository = repository
    }
    
    func execute() throws -> [PesoModel] {
        try repository.fetchData()
    }
}

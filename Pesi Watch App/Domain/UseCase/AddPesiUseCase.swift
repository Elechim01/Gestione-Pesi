//
//  AddPesiUseCase.swift
//  Pesi Watch App
//
//  Created by Michele Manniello on 13/04/26.
//

import Foundation

final class AddPesiUseCase {
    
    private let repository: PesoRepositoryInterface
    
    init(repository: PesoRepositoryInterface) {
        self.repository = repository
    }
    
    func execute(models: [PesoModel]) throws {
        try repository.insertData(models: models)
    }
}

//
//  AddPesiUseCase.swift
//  Pesi
//
//  Created by Michele Manniello on 09/04/26.
//

import Foundation

final class AddPesiUseCase {
    
    private let repository: PesoRepositoryInterface
    
    init(repository: PesoRepositoryInterface) {
        self.repository = repository
    }
    
    func execute(model: PesoModel) throws {
        try repository.insertData(model: model)
    }
}

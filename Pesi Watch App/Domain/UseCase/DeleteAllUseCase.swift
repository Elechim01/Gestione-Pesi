//
//  DeleteAllUseCase.swift
//  Pesi Watch App
//
//  Created by Michele Manniello on 13/04/26.
//

import Foundation

final class DeleteAllUseCase {
    
    private let repository: PesoRepositoryInterface
    
    init(repository: PesoRepositoryInterface) {
        self.repository = repository
    }
    
    func execute() throws {
        try repository.clearAll()
    }
}

//
//  PesoRepository.swift
//  Pesi Watch App
//
//  Created by Michele Manniello on 13/04/26.
//

import Foundation

final class PesoRepository: PesoRepositoryInterface {
   
    private let pesoDataSource: PesoDataSourceProtocol
    
    init(pesoDataSource: PesoDataSourceProtocol) {
        self.pesoDataSource = pesoDataSource
    }
    
    func fetchData() throws -> [PesoModel] {
        let pesoDtos = try pesoDataSource.fetchTutti()
        return  pesoDtos.map {
            PesoMapper.map($0)
        }
    }
    
    func insertData(models: [PesoModel]) throws {
        let dtos = models.map { PesoMapper.map($0) }
        try pesoDataSource.inserisciMolti(dtos)
    }
    
    func clearAll() throws {
        try pesoDataSource.eliminaTutto()
    }
    
}

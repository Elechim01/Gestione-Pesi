//
//  PesoRepository.swift
//  Pesi
//
//  Created by Michele Manniello on 09/04/26.
//


import Foundation

final class PesoRepository: PesoRepositoryInterface {
    
    private let pesoDataSource: PesoDataSourceProtocol
    
    init(pesoDataSource: PesoDataSourceProtocol) {
        self.pesoDataSource = pesoDataSource
    }
    
    func fetchData() throws -> [PesoModel] {
        let pesoDtos = try  pesoDataSource.fetchTutti()
        return  pesoDtos.map {
            PesoMapper.map($0)
        }
    }
    
    func insertData(model: PesoModel) throws {
        let dto = PesoMapper.map(model)
        try pesoDataSource.inserisci(dto)
    }
    
    func deleteData(model: PesoModel) throws {
        let dto = PesoMapper.map(model)
        try pesoDataSource.elimina(dto)
    }
}

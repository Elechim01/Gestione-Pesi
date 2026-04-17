//
//  PesoDataSource.swift
//  Pesi
//
//  Created by Michele Manniello on 09/04/26.
//

import Foundation
import SwiftData

protocol PesoDataSourceProtocol {
    func fetchTutti() throws -> [PesoDTO]
    func inserisci(_ dto: PesoDTO) throws
    func elimina(_ dto: PesoDTO) throws
    func eliminaTutto() throws
    func inserisciMolti(_ dtos: [PesoDTO]) throws
}

protocol SwiftDataDataSource: PesoDataSourceProtocol {
    func salva() throws
}

final class PesoDataSource: SwiftDataDataSource {
  
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func fetchTutti() throws -> [PesoDTO] {
        let descriptor = FetchDescriptor<PesoDTO>(sortBy: [SortDescriptor(\.id)])
        return try modelContext.fetch(descriptor)
    }
    
    func inserisci(_ dto: PesoDTO) throws {
        let idCercato = dto.id
        let fetchDescriptor = FetchDescriptor<PesoDTO>(predicate: #Predicate { $0.id == idCercato })
        if let esiste = try modelContext.fetch(fetchDescriptor).first {
            esiste.numero = dto.numero
            esiste.colore = dto.colore
            esiste.piramidale = dto.piramidale
            esiste.min = dto.min
            esiste.max = dto.max
            esiste.normal = dto.normal
            
        } else {
            modelContext.insert(dto)
        }

       try salva()
    }
    
    // Nel tuo PesoDataSource
    func inserisciMolti(_ dtos: [PesoDTO]) throws {
        for dto in dtos {
            // Esegui solo l'inserimento o l'aggiornamento in memoria
            let idCercato = dto.id
            let fetchDescriptor = FetchDescriptor<PesoDTO>(predicate: #Predicate { $0.id == idCercato })
            
            if let esiste = try modelContext.fetch(fetchDescriptor).first {
                esiste.numero = dto.numero
                esiste.numero = dto.numero
                esiste.colore = dto.colore
                esiste.piramidale = dto.piramidale
                esiste.min = dto.min
                esiste.max = dto.max
                esiste.normal = dto.normal
            } else {
                modelContext.insert(dto)
            }
        }
        try salva()
    }
    
    func elimina(_ dto: PesoDTO) throws {
        let idDaCancellare = dto.id
        try modelContext.delete(model: PesoDTO.self, where: #Predicate { peso in
            peso.id == idDaCancellare
        })
        try salva()
    }
    
    func eliminaTutto() throws {
        try modelContext.delete(model: PesoDTO.self)
        try salva()
    }
    
     func salva() throws {
        try modelContext.save()
    }
}

//
//  DependecyInjection.swift
//  Pesi Watch App
//
//  Created by Michele Manniello on 13/04/26.
//

import Foundation
import SwiftData

final class DependecyInjection {
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    //MARK: MAKE DATASOURCE
    private lazy var pesoDataSource: PesoDataSourceProtocol = {
        PesoDataSource(modelContext: modelContext)
    }()
    
    //MARK: MAKE REPOSITORY
    private lazy var pesoRepository: PesoRepositoryInterface = {
        return PesoRepository(pesoDataSource: pesoDataSource)
    }()
    
    // MARK: MAKE USE CASE
    private lazy var fetchPesiUseCase: FetchPesiUseCase = {
        return FetchPesiUseCase(repository: pesoRepository)
    }()
    
    private lazy var deleteAllUseCase: DeleteAllUseCase = {
        return DeleteAllUseCase(repository: pesoRepository)
    }()
    
    private lazy var addPesiUseCase: AddPesiUseCase = {
        return AddPesiUseCase(repository: pesoRepository)
    }()
    
    @MainActor
    func createHomeViewModel() -> HomeViewModel {
        HomeViewModel(addPesiUseCase: addPesiUseCase,
                      deleteAllUseCase: deleteAllUseCase,
                      fetchPesiUseCase: fetchPesiUseCase)
    }
}

//
//  DependecyInjection.swift
//  Pesi
//
//  Created by Michele Manniello on 09/04/26.
//

import Foundation
import SwiftData

class DependecyInjection {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // MARK: MAKE DATASOURCE
    private lazy var pesoDataSource: PesoDataSourceProtocol  = {
        PesoDataSource(modelContext: modelContext)
    }()
    
    //MARK: MAKE REPOSITORY
    private lazy var pesoRepository: PesoRepositoryInterface = {
        return PesoRepository(pesoDataSource: pesoDataSource)
    }()
    
    //MARK: MAKE USE CASE
    private lazy var fetchPesiUseCase: FetchPesiUseCase = {
        return FetchPesiUseCase(repository: pesoRepository)
    }()
    
    private lazy var addPesiUseCase: AddPesiUseCase = {
        return AddPesiUseCase(repository: pesoRepository)
    }()
    
    private lazy var deletePesiUseCase: DeletePesiUseCase = {
        return DeletePesiUseCase(repository: pesoRepository)
    }()
    
    @MainActor
    func createHomeViewModel() -> HomeViewModel {
        HomeViewModel(fetchPesiUseCase: fetchPesiUseCase,
                      addPesiUseCase: addPesiUseCase,
                      deletePesiUseCase: deletePesiUseCase)
    }
}

//
//  PesiTests.swift
//  PesiTests
//
//  Created by Michele Manniello on 09/04/26.
//

import XCTest
import SwiftData
@testable import Pesi
internal import SwiftUI


final class PesiTests: XCTestCase {
    var mockModelContext: ModelContext!
    var container: ModelContainer!
    var di: DependecyInjection!
    var homeViewModel: HomeViewModel!
    
    @MainActor
    override func setUpWithError() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: PesoDTO.self, configurations: config)
        mockModelContext = container.mainContext
        
        // 2. Iniezione delle dipendenze per il test
        di = DependecyInjection(modelContext: mockModelContext)
        homeViewModel = di.createHomeViewModel()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
    }
    
    
    @MainActor
    func test_01_InizialmenteDeveEssereVuoto() throws {
        // Act
        homeViewModel.fetchPesi()
        
        // Assert
        XCTAssertEqual(homeViewModel.pesi.count, 0, "Il database dovrebbe essere vuoto all'avvio.")
    }
    
    @MainActor
    func test_02_AggiuntaPeso_DeveAggiornareLaLista() throws {
        // Arrange
        let nuovoPeso = PesoModel(
            numero: 50,
            colore: .blue,
            piramidale: true,
            min: 10,
            max: 20,
            normal: nil
        )
        
        // Act
        homeViewModel.addPesi(model: nuovoPeso)
        
        // Assert
        // Non serve chiamare fetchPesi() perché addPesi lo chiama già internamente
        XCTAssertEqual(homeViewModel.pesi.count, 1, "La lista dovrebbe contenere 1 elemento dopo l'aggiunta.")
        XCTAssertEqual(homeViewModel.pesi.first?.numero, 50)
        XCTAssertEqual(homeViewModel.pesi.first?.id, nuovoPeso.id)
    }
    @MainActor
    func test_03_EliminazionePeso_DeveSvuotareLaLista() throws {
        // Arrange: Aggiungiamo prima un peso
        let pesoDaEliminare = PesoModel(
            numero: 30,
            colore: .red,
            piramidale: false,
            min: nil,
            max: nil,
            normal: 10
        )
        homeViewModel.addPesi(model: pesoDaEliminare)
        XCTAssertEqual(homeViewModel.pesi.count, 1) // Verifica intermedia
        
        // Act: Eliminiamo l'elemento appena aggiunto
        // Prendiamo l'elemento dalla lista del VM per essere sicuri che l'ID corrisponda
        if let pesoInLista = homeViewModel.pesi.first {
            homeViewModel.deletePesi(model: pesoInLista)
        }
        
        // Assert
        XCTAssertEqual(homeViewModel.pesi.count, 0, "La lista dovrebbe tornare vuota dopo l'eliminazione.")
    }
    
    
    
    
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}

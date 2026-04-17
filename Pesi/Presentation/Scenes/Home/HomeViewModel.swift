//
//  HomeViewModel.swift
//  Pesi
//
//  Created by Michele Manniello on 09/04/26.
//

import Foundation
import SwiftUI
import LocalAuthentication
import ElechimCore

@MainActor
@Observable
class HomeViewModel {
    
    private let fetchPesiUseCase: FetchPesiUseCase
    private let addPesiUseCase: AddPesiUseCase
    private let deletePesiUseCase: DeletePesiUseCase
    
    var pesi: [PesoModel] = []
    var isSyncing: Bool = false
    var errorMessage: String = ""
    var showError: Bool = false
    
    var isWatchOnline: Bool {
        WatchConnector.shared.isReachable
    }
    
    init(fetchPesiUseCase: FetchPesiUseCase,
         addPesiUseCase: AddPesiUseCase,
         deletePesiUseCase: DeletePesiUseCase) {
        
        self.fetchPesiUseCase = fetchPesiUseCase
        self.addPesiUseCase = addPesiUseCase
        self.deletePesiUseCase = deletePesiUseCase
    }
    
    func fetchPesi() {
        do {
            pesi = try fetchPesiUseCase.execute()
        } catch  {
            Utils.showError(alertMessage: &errorMessage, showAlert: &showError, from: error)
        }
    }
    
    func addPesi(model: PesoModel) {
        do {
            try addPesiUseCase.execute(model: model)
            fetchPesi()
        } catch  {
            Utils.showError(alertMessage: &errorMessage, showAlert: &showError, from: error)
        }
    }
    
    func deletePesi(model: PesoModel) {
        do {
            try deletePesiUseCase.execute(model: model)
            fetchPesi()
        } catch {
            Utils.showError(alertMessage: &errorMessage, showAlert: &showError, from: error)
        }
    }
    
    func deletePeso(at offset: IndexSet) {
        offset.forEach { index in
            let pesoDaEliminare = self.pesi[index]
            deletePesi(model: pesoDaEliminare)
        }
    }
    
    func addPesi(id: String?,
                 numero: Int,
                 colore: Color,
                 isPiramidale: Bool,
                 min: Int,
                 max: Int,
                 normal:Int
    ) {
        let model = PesoModel(id: id ?? UUID().uuidString,
                              numero: numero,
                              colore: colore,
                              piramidale: isPiramidale,
                              min: isPiramidale ? min : nil,
                              max: isPiramidale ? max : nil,
                              normal: !isPiramidale ? normal : nil)
        addPesi(model: model)
        
    }
    
    func checkWatchIsOnline() {
        WatchConnector.shared.updateReachability()
    }
    
    // lo metto dentro
    func sendToWatch() async {
        // mando tutto poi dal watch quando ricevo devo pulire tutto e riscrivere tutto
        isSyncing = true
        defer {
            isSyncing = false
        }
        do {
            let pesiDTO = pesi.map { PesoMapper.map($0) }
            let pesiTransfer = pesiDTO.map { PesoMapper.map(dtoForTransfer: $0)}
            try  await  WatchConnector.shared.sendMessage(pesoTransfer: pesiTransfer)
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            
        } catch  {
            print("Rifare la sincronizzazione")
            Utils.showError(alertMessage: &errorMessage, showAlert: &showError, from: error)
        }
        
    }
    
}



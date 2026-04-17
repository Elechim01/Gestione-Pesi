//
//  HomeViewModel.swift
//  Pesi Watch App
//
//  Created by Michele Manniello on 13/04/26.
//

import Foundation
import SwiftUI
import ElechimCore

@MainActor
@Observable
final class HomeViewModel {
    
    private let addPesiUseCase: AddPesiUseCase
    private let deleteAllUseCase: DeleteAllUseCase
    private let fetchPesiUseCase: FetchPesiUseCase
    private let iphoneconnection: IphoneConnector
    
    var pesi: [PesoModel] = []
    var errorMessage: String = ""
    var showError: Bool = false
    
    init(addPesiUseCase: AddPesiUseCase, deleteAllUseCase: DeleteAllUseCase, fetchPesiUseCase: FetchPesiUseCase) {
        self.addPesiUseCase = addPesiUseCase
        self.deleteAllUseCase = deleteAllUseCase
        self.fetchPesiUseCase = fetchPesiUseCase
        self.iphoneconnection = IphoneConnector.shared
        
        listenToStream()
    }
    
    private func listenToStream() {
        Task {
            for await result in iphoneconnection.pesiStream {
                switch result {
                case .success(let transfer):
                    await applicaAggiornamento(transfer)
                case .failure(let error):
                    Utils.showError(alertMessage: &errorMessage, showAlert: &showError, from: error)
                }
            }
        }
    }
    
    private func applicaAggiornamento(_ transfer: [PesoTransfer]) async {
        do {
            let newDTO = transfer.map { PesoMapper.map(transferForDto: $0)}
            let newPesoModel = newDTO.map { PesoMapper.map($0)}
            try deleteAllUseCase.execute()
            try addPesiUseCase.execute(models: newPesoModel)
            
            fetchPesi()
        } catch  {
            print("Errore ricezione stream: \(error.localizedDescription)")
            Utils.showError(alertMessage: &errorMessage, showAlert: &showError, from: error)
        }
    }
    
    func fetchPesi() {
        do {
            self.pesi = try fetchPesiUseCase.execute()
        } catch {
            Utils.showError(alertMessage: &errorMessage, showAlert: &showError, from: error)
        }
    }
    
}

//
//  WatchConnector.swift
//  Pesi
//
//  Created by Michele Manniello on 10/04/26.
//

import Foundation
import ElechimCore
import WatchConnectivity

@Observable
final class WatchConnector: NSObject, WCSessionDelegate {
    
    static let shared = WatchConnector()
    var session: WCSession?
    
    var isReachable: Bool = false
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            self.session = WCSession.default
            self.session?.delegate = self
            self.session?.activate()
        }
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        let status = session.activationState == .activated && session.isReachable
        Task { @MainActor in
            self.isReachable = status
        }
    }
    
    @MainActor
    func updateReachability() {
        if let session = self.session {
            self.isReachable = session.activationState == .activated && session.isReachable
        } else {
            self.isReachable = false
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        self.session = session
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        self.session = session
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        self.session = session
    }
    
    func sendMessage(pesoTransfer: [PesoTransfer]) async throws {
        guard let session, isReachable else {
            throw CustomError.connectionError
        }
        
        let data = try JSONEncoder().encode(pesoTransfer)
        
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            // Usiamo entrambi i rami per essere sicuri di chiamare il resume
            session.sendMessageData(data) { reply in
                // Se ricevi una risposta (anche vuota), l'invio è riuscito
                continuation.resume(returning: ())
            } errorHandler: { error in
                // Se c'è un problema, lanciamo l'errore
                continuation.resume(throwing: error)
            }
        }
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
        // 1. Elabora il dato ricevuto
        // Esempio: let peso = try? JSONDecoder().decode(PesoModel.self, from: messageData)
        
        // 2. IMPORTANTE: Rispondi subito per sbloccare la 'continuation' dell'altro dispositivo
        replyHandler(Data()) // Invia un Data vuoto come "ACK" (Acknowledge)
        
        // 3. Notifica la UI o salva i dati
        print("Dati ricevuti con successo!")
    }
    
}

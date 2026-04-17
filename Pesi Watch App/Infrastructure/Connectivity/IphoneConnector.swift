//
//  IphoneConnector.swift
//  Pesi Watch App
//
//  Created by Michele Manniello on 13/04/26.
//

import Foundation
import ElechimCore
import WatchConnectivity

final class IphoneConnector: NSObject, WCSessionDelegate {
    
    static let shared = IphoneConnector()
    var session: WCSession?
    
    private var dataContinuation: AsyncStream<Result<[PesoTransfer],Error>>.Continuation?
    
    lazy var pesiStream: AsyncStream<Result<[PesoTransfer],Error>> = {
        AsyncStream { continuation in
            self.dataContinuation = continuation
        }
    }()
    
    var online: Bool {
        guard let session = self.session else { return false }
        return session.isReachable
    }
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            self.session = WCSession.default
            self.session?.delegate = self
            self.session?.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        self.session = session
        
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
        do {
            let response = try JSONDecoder().decode([PesoTransfer].self, from: messageData)
            dataContinuation?.yield(.success(response))
            replyHandler(Data())
            
        } catch {
            
            print(error.localizedDescription)
            dataContinuation?.yield(.failure(error))
            replyHandler(Data())
        }
    }
}

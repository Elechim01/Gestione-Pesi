//
//  AuthServices.swift
//  Pesi
//
//  Created by Michele Manniello on 09/04/26.
//

import Foundation
import LocalAuthentication

final class AuthService: AuthServiceProtocol {
    func authenticate() async throws -> Bool {
        let context = LAContext()
        // Questo permette di mostrare il tasto "Inserisci codice" se il FaceID fallisce
        context.localizedFallbackTitle = "Usa codice dispositivo"
        
        let reason = "Accedi per visualizzare i tuoi pesi"
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            do {
                return try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
            } catch let authError as LAError where authError.code == .userFallback {
                return try await context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason)
            } catch {
                throw error
            }
        } else {
            return try await context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason)
        }
    }
    
}

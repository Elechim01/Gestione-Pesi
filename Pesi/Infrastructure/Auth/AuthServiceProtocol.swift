//
//  AuthServiceProtocol.swift
//  Pesi
//
//  Created by Michele Manniello on 09/04/26.
//

import Foundation

protocol AuthServiceProtocol {
    func authenticate() async throws -> Bool
}

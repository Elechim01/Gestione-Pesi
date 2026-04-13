//
//  PesoTransfer.swift
//  Pesi
//
//  Created by Michele Manniello on 10/04/26.
//

import Foundation

struct PesoTransfer: Codable {
    var id: String
    var numero: Int
    var colore: String
    var piramidale: Bool
    var min: Int?
    var max: Int?
    var normal: Int?
    
    init(id: String,
         numero: Int,
         colore: String,
         piramidale: Bool,
         min: Int?,
         max: Int?,
         normal: Int?) {
        self.id = id
        self.numero = numero
        self.colore = colore
        self.piramidale = piramidale
        self.min = min
        self.max = max
        self.normal = normal
    }
}

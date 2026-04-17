//
//  PesoModel.swift
//  Pesi
//
//  Created by Michele Manniello on 09/04/26.
//

import Foundation
import SwiftUI

struct PesoModel: Identifiable {
    var id: String?
    let numero: Int?
    let colore: Color?
    let piramidale: Bool?
    let min: Int?
    let max: Int?
    let normal: Int?
    
    init(id: String = UUID().uuidString, numero: Int, colore: Color, piramidale: Bool, min: Int?, max: Int?, normal: Int?) {
        self.id = id
        self.numero = numero
        self.colore = colore
        self.piramidale = piramidale
        self.min = min
        self.max = max
        self.normal = normal
    }
    
    init(){
        id = nil
        numero = nil
        colore = nil
        piramidale = nil
        min = nil
        max = nil
        normal = nil
    }
}

//
//  PesoMapper.swift
//  Pesi
//
//  Created by Michele Manniello on 09/04/26.
//

import SwiftUI

/// Classe dedicata alla trasformazione dei dati grezzi (DTO) in entità di business (Domain Models).
///
/// Isola la logica di parsing e conversione delle unità di misura, mantenendo i mod
final class PesoMapper {
    
    /// Converte un oggetto di risposta della lista in un modello per la visualizzazione.
    /// - Parameter dto: L'entry grezza proveniente da SwiftData.
    /// - Returns: Un `PesoModel` pronto all'uso
    static func map(_ dto: PesoDTO) -> PesoModel {
        PesoModel(id: dto.id,
                  numero: dto.numero,
                  colore: Color(hex: dto.colore),
                  piramidale: dto.piramidale,
                  min: dto.min,
                  max: dto.max,
                  normal: dto.normal)
    }
    
    /// Converte un oggetto per l'aggiunta a swift data
    /// - Parameter model: L'entry creata da UI
    /// - Returns: Un `PesoDTO` pronta per essere salvata
    static func map(_ model: PesoModel) -> PesoDTO {
        PesoDTO(id: model.id ?? "",
                numero: model.numero ?? 0,
                colore: model.colore?.toHex() ?? "",
                piramidale: model.piramidale ?? false,
                min: model.min,
                max: model.max,
                normal: model.normal)
    }
    
    /// Converte un oggetto per il passaggio al watch
    /// - Parameter model: L'entry creata da UI
    /// - Returns: Un `PesoTransfer` pronta per essere inviata al watch
    static func map(dtoForTransfer dto: PesoDTO) -> PesoTransfer {
        PesoTransfer(id: dto.id,
                     numero: dto.numero,
                     colore: dto.colore,
                     piramidale: dto.piramidale,
                     min: dto.min,
                     max: dto.max,
                     normal: dto.normal)
    }
    
    
    /// Converte un oggetto per il passaggio al watch
    /// - Parameter transferForDto: L'entry passata da IPhone
    /// - Returns: Un `PesoDTO` pronta per essere salvata
    static func map(transferForDto transfer: PesoTransfer) -> PesoDTO {
        PesoDTO(id: transfer.id,
                numero: transfer.numero,
                colore: transfer.colore,
                piramidale: transfer.piramidale,
                min: transfer.min,
                max: transfer.max,
                normal: transfer.normal)
    }
}

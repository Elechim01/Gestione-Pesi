//
//  PesoRow.swift
//  Pesi
//
//  Created by Michele Manniello on 13/04/26.
//

import SwiftUI
import SwiftData

struct PesoRow: View {
    
    var pesoModel: PesoModel
    private var numberCricleWith: CGFloat
    private var numberCricleHeight: CGFloat
    
    init(pesoModel: PesoModel,
         numberCricleWith: CGFloat = 44,
         numberCricleHeight: CGFloat =  44  ) {
        self.pesoModel = pesoModel
        self.numberCricleWith = numberCricleWith
        self.numberCricleHeight = numberCricleHeight
    }
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .foregroundStyle((pesoModel.colore ?? .gray).gradient)
                .frame(width: numberCricleWith, height: numberCricleHeight)
                .overlay {
                    Text("\(pesoModel.numero ?? 0)")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
            
            VStack(alignment: .leading, spacing: 2) {
                if pesoModel.piramidale ?? false {
                    Text("Piramidale")
                        .font(.caption2.bold())
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)
                    
                    HStack(spacing: 8) {
                        Label("\(pesoModel.min ?? 0) kg",
                              systemImage: "arrow.down")
                        Label("\(pesoModel.max ?? 0) kg",
                              systemImage: "arrow.up")
                    }
                    .font(.subheadline.weight(.semibold))
                } else {
                    Text("Carico Standard")
                        .font(.caption2.bold())
                        .foregroundStyle(.secondary)
                        .textCase(.uppercase)
                    
                    Text("\(pesoModel.normal ?? 0) kg")
                        .font(.headline)
                }
            }
            
        }
    }
}

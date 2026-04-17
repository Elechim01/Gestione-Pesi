//
//  AddPesoView.swift
//  Pesi
//
//  Created by Michele Manniello on 09/04/26.
//

import SwiftUI
import SwiftData
import ElechimCore

struct AddPesoView: View {
    @Environment(HomeViewModel.self) private var homeViewModel
    @State private var numero: Int
    @State private var colore: Color
    @State private var isPiramidale: Bool
    @State private var min: Int
    @State private var max: Int
    @State private var normal: Int
    @State private var id: String?
    @Environment(\.dismiss) var dismiss
    
    init(pesoModel: PesoModel? = nil) {
        id = pesoModel?.id
        numero = pesoModel?.numero ?? 0
        colore = pesoModel?.colore ?? .white
        isPiramidale = pesoModel?.piramidale ?? false
        min = pesoModel?.min ?? 0
        max = pesoModel?.max ?? 0
        normal = pesoModel?.normal ?? 0
        
    }
    
    private var check: Bool {
        if isPiramidale {
            return min < max
        } else {
            return normal > 0 // O semplicemente true se il peso 0 è ammesso
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.secondary)
                        .padding(12)
                        .glassEffect() // Effetto vetro sul singolo tasto
                }

                Spacer()

                Text(id == nil ? "Nuovo Peso" : "Modifica Peso")
                    .font(.headline)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .glassEffect()

                Spacer()

                Button {
                    guard check else { return }
                    homeViewModel.addPesi(id: id,
                                          numero: numero,
                                          colore: colore,
                                          isPiramidale: isPiramidale,
                                          min: min,
                                          max: max,
                                          normal: normal)
                    dismiss()
                } label: {
                    Image(systemName: "checkmark")
                        .font(.system(size: 20, weight: .bold))
                        .padding(12)
                        .glassEffect()
                }
            }
            .padding(.top)
            .padding(.horizontal)
            .background(.ultraThinMaterial)

            Form {
                Section {
                    HStack {
                        Label("Numero", systemImage: "tag.circle.fill")
                        Spacer()
                        Text("\(numero)").bold()
                        Stepper("", value: $numero, in: 0...20)
                            .labelsHidden()
                       
                    }
                    ColorPicker(selection: $colore) {
                        Label("Colore", systemImage: "paintpalette.fill")
                    }
                } header: { Text("Estetica") }

                Section {
                    Toggle("Piramidale", isOn: $isPiramidale.animation())
                    
                    if isPiramidale {
                        // Picker compatti (stile Menu) visto che non abbiamo la navigazione
                        Picker("Minimo", selection: $min) {
                            ForEach(0...100, id: \.self) { Text("\($0) kg").tag($0) }
                        }
                        .pickerStyle(.menu)
                        
                        Picker("Massimo", selection: $max) {
                            ForEach(0...100, id: \.self) { Text("\($0) kg").tag($0) }
                        }
                        .pickerStyle(.menu)
                    } else {
                        Picker("Carico", selection: $normal) {
                            ForEach(0...100, id: \.self) { Text("\($0) kg").tag($0) }
                        }
                        .pickerStyle(.menu)
                    }
                } header: { Text("Dati Tecnici") }
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: PesoDTO.self, configurations: config)
    
    // 2. Usiamo la tua DI per creare il ViewModel
    let di = DependecyInjection(modelContext: container.mainContext)
    let viewModel =  di.createHomeViewModel()
    SheetPreviewWrapper(showSheet: true) {
        AddPesoView()
            .environment(viewModel)
    }
   
}

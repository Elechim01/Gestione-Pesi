//
//  PesiApp.swift
//  Pesi
//
//  Created by Michele Manniello on 09/04/26.
//

import SwiftUI
import SwiftData

@main
struct PesiApp: App {
    let container: ModelContainer?
    let di: DependecyInjection?
    
    init() {
       do {
            let schema = Schema([PesoDTO.self])
            let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            
            let container = try ModelContainer(for: schema, configurations: [config])
            self.container = container
            self.di = DependecyInjection(modelContext: container.mainContext)
        } catch {
            // Qui invece di crashare, logghiamo l'errore
            print("Errore critico SwiftData: \(error)")
            container = nil
            di = nil
        }
    }
    
    var body: some Scene {
        WindowGroup {
            if let di = di {
                // Se la DI è pronta, partiamo col ViewModel
                ContentView(homeViewModel: di.createHomeViewModel())
                    .modelContainer(container!)
            } else {
                // Schermata di fallback se il database esplode
                ContentUnavailableView("Errore Database",
                                       systemImage: "exclamationmark.triangle",
                                       description: Text("Non è stato possibile inizializzare l'archivio. serve più spazio sul disco"))
            }
        }
    }
}

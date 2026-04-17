//
//  PesiApp.swift
//  Pesi Watch App
//
//  Created by Michele Manniello on 09/04/26.
//

import SwiftUI
import SwiftData

@main
struct Pesi_Watch_AppApp: App {
    
    let container: ModelContainer
    @MainActor
    private var dependencyInjection: DependecyInjection
    
    init() {
        do {
            let schema = Schema([PesoDTO.self])
            let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            container = try ModelContainer(for: schema, configurations: config)
            self.dependencyInjection = DependecyInjection(modelContext: container.mainContext)
        } catch  {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            container = try! ModelContainer(for: PesoDTO.self, configurations: config)
            dependencyInjection = DependecyInjection(modelContext: container.mainContext)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView(homeViewModel: dependencyInjection.createHomeViewModel(),)
        }
    }
}

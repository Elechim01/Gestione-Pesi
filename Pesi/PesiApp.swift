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
    
    @State private var coordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch coordinator.state {
                case .initializing:
                    ProgressView("Avvio l'app ...")
                case .locked:
                    LockedView()
                case .error(let messaggio):
                    ContentUnavailableView(
                        "Errore Critico",
                        systemImage: "exclamationmark.triangle",
                        description: Text(messaggio)
                    )
                case .authorized:
                    if let di = coordinator.di {
                        HomeView(homeViewModel: di.createHomeViewModel())
                    }
                case .loading:
                    ProgressView("Caricamento...")
                }
            }
            .task {
                await coordinator.checkAuthentication()
            }
            
        }
    }
    // TODO: MOVE IN SEPARATE VIEW
    @ViewBuilder
    func LockedView() -> some View {
        VStack {
            Image(systemName: "lock.fill").font(.largeTitle)
            Button("Sblocca App") {
                Task { await coordinator.checkAuthentication() }
            }
        }
    }
}

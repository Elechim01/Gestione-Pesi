//
//  ContentView.swift
//  Pesi
//
//  Created by Michele Manniello on 09/04/26.
//

import SwiftUI
import SwiftData
/*
struct ContentView: View {
    // @State private var homeViewModel: HomeViewModel
   
    
    /* init(homeViewModel: HomeViewModel) {
     self.homeViewModel = homeViewModel
     }*/
    
    var body: some View {
        Group {
            switch coordinator.state {
            case .locked:
                LockedView()
            case .loading:
                ProgressView()
            case .authorized:
                HomeView()
            }
        }
        .task {
            await coordinator.checkAuthentication()
        }
    }
    
    
}

#Preview {
    /*
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: PesoDTO.self, configurations: config)
    
    // 2. Usiamo la tua DI per creare il ViewModel
    let di = DependecyInjection(modelContext: container.mainContext)
    ContentView(homeViewModel:  di.createHomeViewModel() )*/
    ContentView()
}
*/

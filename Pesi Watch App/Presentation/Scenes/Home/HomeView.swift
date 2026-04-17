//
//  HomeView.swift
//  Pesi Watch App
//
//  Created by Michele Manniello on 13/04/26.
//

import SwiftUI
import SwiftData
import ElechimCore

struct HomeView: View {
    
    @Bindable var homeViewModel: HomeViewModel
    @Environment(\.isPreview) var isPreview
    
    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if homeViewModel.pesi.isEmpty {
                    ContentUnavailableView {
                        Label("Elenco pesi", systemImage: "scalemass")
                    } description: {
                        Text("Sincronizza gli elementi dall'iPhone")
                    }
                } else {
                    // Ordiniamo i dati PRIMA di passarli alla List
                    let pesiOrdinati = homeViewModel.pesi.sorted {
                        ($0.numero ?? 0) < ($1.numero ?? 0)
                    }
                    
                    List(pesiOrdinati) { peso in
                        PesoRow(pesoModel: peso,
                                numberCricleWith: 24,
                                numberCricleHeight: 24)
                        .foregroundStyle(.primary)
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Pesi")
            .alert(homeViewModel.errorMessage, isPresented: $homeViewModel.showError, actions: {
                Button("Chiudi") {
                    homeViewModel.showError = false
                }
            })
            .onAppear {
                if !isPreview {
                    homeViewModel.fetchPesi()
                }
            }
        }
    }
}

#Preview {
    let vm: HomeViewModel = {
        let di = DependecyInjection(modelContext: PreviewContainer.container.mainContext)
        let viewModel = di.createHomeViewModel()
        viewModel.pesi = pesiMock
        return viewModel
    }()
    
    HomeView(homeViewModel: vm)
}

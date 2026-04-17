//
//  HomeView.swift
//  Pesi
//
//  Created by Michele Manniello on 09/04/26.
//

import SwiftUI
import SwiftData
import ElechimCore

struct HomeView: View {
    @Bindable var homeViewModel: HomeViewModel
    @State private var editPeso: PesoModel?
    @State private var sendtoWatch: Bool = false
    
    
    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel
    }
    var body: some View {
        NavigationStack {
            List{
                ForEach(homeViewModel.pesi.sorted(by: { ($0.numero ?? 0 ) < ($1.numero ?? 1)}),id:\.id) { pesi in
                    Button {
                        self.editPeso = pesi
                    } label: {
                      PesoRow(pesoModel: pesi)
                    }
                    .foregroundStyle(.primary)
                    .alignmentGuide(.listRowSeparatorLeading, computeValue: { d in
                        d[.leading]
                    })
                    .padding(.vertical, 4)
                    .listRowSeparatorTint(pesi.colore?.opacity(0.3))
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                }
                .onDelete { index in
                    self.homeViewModel.deletePeso(at: index)
                }
            }
            .navigationTitle(Text("Elenco dei pesi"))
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        editPeso = PesoModel()
                    } label: {
                        Label("Aggiungi", systemImage: "plus")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        sendtoWatch.toggle()
                    } label: {
                        Label("Invia all'apple watch",
                              systemImage: "applewatch.and.arrow.forward")
                    }
                }
            }
        }
        .alert(homeViewModel.errorMessage, isPresented: $homeViewModel.showError, actions: {
            Button("Chiudi") {
                homeViewModel.showError = false
            }
        })
        .disabled(homeViewModel.isSyncing)
            .overlay {
                if homeViewModel.isSyncing {
                    ZStack {
                        Color.black.opacity(0.2)
                            .ignoresSafeArea()
                        
                        VStack(spacing: 12) {
                            ProgressView()
                                .controlSize(.large)
                            Text("Sincronizzazione...")
                                .font(.subheadline.bold())
                                .foregroundStyle(.secondary)
                        }
                        .padding(24)
                        .background(.ultraThinMaterial)
                        .cornerRadius(16)
                    }
                }
            }
        .task({
            homeViewModel.fetchPesi()
        })
        .sheet(item: $editPeso) { peso in
            AddPesoView(pesoModel: peso)
                .environment(homeViewModel)
        }
        .sheet(isPresented: $sendtoWatch) {
            SendToWatch()
                .environment(homeViewModel)
        }
    }
}

#Preview {
    let vm: HomeViewModel = {
        let di = DependecyInjection(modelContext: PreviewContainer.container.mainContext)
        let viewModel = di.createHomeViewModel()
        
        for peso in pesiMock {
            viewModel.addPesi(model: peso)
        }
        
        return viewModel
    }()

    return HomeView(homeViewModel: vm)
}

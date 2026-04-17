//
//  SendToWatch.swift
//  Pesi
//
//  Created by Michele Manniello on 17/04/26.
//

import SwiftUI
import SwiftData
import ElechimCore

struct SendToWatch: View {
    @Environment(HomeViewModel.self) private var homeViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                // --- Sezione Icona Animata ---
                ZStack {
                    Circle()
                        .fill(homeViewModel.isWatchOnline ? .green.opacity(0.1) : .red.opacity(0.1))
                        .frame(width: 120, height: 120)
                    
                    Image(systemName: homeViewModel.isWatchOnline ? "applewatch.radiowaves.left.and.right" : "applewatch.slash")
                        .font(.system(size: 50))
                        .foregroundStyle(homeViewModel.isWatchOnline ? .green : .red)
                        .contentTransition(.symbolEffect(.replace)) // Animazione fluida al cambio stato
                }
                .padding(.top, 40)

                // --- Testo Informativo ---
                VStack(spacing: 8) {
                    Text(homeViewModel.isWatchOnline ? "Watch Connesso" : "Watch non raggiungibile")
                        .font(.headline)
                    
                    Text(homeViewModel.isWatchOnline ?
                         "Il tuo Apple Watch è pronto a ricevere i dati aggiornati." :
                         "Assicurati che l'app Pesi sia aperta sul tuo orologio per continuare.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                }

                Spacer()

                HStack {
                    Text("Stato connessione")
                        .font(.footnote.bold())
                        .foregroundStyle(.secondary)
                    Spacer()
                    HStack(spacing: 6) {
                        Circle()
                            .frame(width: 8, height: 8)
                            .foregroundStyle(homeViewModel.isWatchOnline ? .green : .red)
                        Text(homeViewModel.isWatchOnline ? "Online" : "Offline")
                            .font(.footnote)
                            .fontWeight(.medium)
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
                .padding(.horizontal)

                Button {
                    Task {
                        await homeViewModel.sendToWatch()
                        dismiss()
                    }
                } label: {
                    HStack {
                        if homeViewModel.isSyncing {
                            ProgressView()
                                .tint(.white)
                                .padding(.trailing, 8)
                        }
                        Text(homeViewModel.isSyncing ? "Sincronizzazione..." : "Invia Dati")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background {
                        if homeViewModel.isWatchOnline {
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.blue.gradient) 
                        } else {
                            RoundedRectangle(cornerRadius: 14)
                                .fill(.ultraThinMaterial)
                        }
                    }
                    .foregroundColor(.white)
                    .cornerRadius(14)
                }
                .disabled(!homeViewModel.isWatchOnline || homeViewModel.isSyncing)
                .padding(.horizontal)
                .padding(.bottom, 30)
            }
            .navigationTitle("Sincronizzazione")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Chiudi") { dismiss() }
                }
            }
        }
        .onAppear {
            homeViewModel.checkWatchIsOnline()
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
        SendToWatch()
            .environment(viewModel)
    }
}

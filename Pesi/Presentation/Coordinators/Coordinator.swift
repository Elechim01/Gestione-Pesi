import UIKit
import SwiftData

@Observable
final class AppCoordinator {
    enum AppState {
        case initializing
        case locked
        case error(String)
        case authorized
        case loading
    }
    
    var state: AppState = .initializing
    var di: DependecyInjection?
    var container: ModelContainer?
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
        setupApp()
    }
    
    private func setupApp() {
        do {
            let schema = Schema([PesoDTO.self])
            let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            let container = try ModelContainer(for: schema, configurations: [config])
            self.container = container
            self.di = DependecyInjection(modelContext: container.mainContext)
            self.state = .locked
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    @MainActor
    func checkAuthentication() async {
        do {
            state = .loading
            let success =  try await authService.authenticate()
            state  = success ? .authorized : .locked
            
        } catch  {
            state = .locked
            print("Errore autenticazione: \(error)")
        }
    }
    
}

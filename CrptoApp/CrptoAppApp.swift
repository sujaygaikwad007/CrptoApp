import SwiftUI

@main
struct CrptoAppApp: App {
    
    @StateObject private var vm  = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            
            NavigationView{
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(vm)
            
        }
    }
}

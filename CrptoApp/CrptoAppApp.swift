import SwiftUI

@main
struct CrptoAppApp: App {
    var body: some Scene {
        WindowGroup {
            
            NavigationView{
                HomeView()
                    .navigationBarHidden(true)
            }
         
        }
    }
}

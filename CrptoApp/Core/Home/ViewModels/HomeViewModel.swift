import Foundation
import Combine

class HomeViewModel : ObservableObject{
    
    @Published var allCoins : [CoinModel] = []
    @Published var portfolioCoins : [CoinModel] = []
    
    private let dataService = CoinDataService()
    private var cancelable = Set<AnyCancellable>()
    
    init(){
        addSubscriberes()
        
    }
    
    func addSubscriberes(){
        
        dataService.$allCoins
            .sink { [weak self](returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancelable)
        
    }
    
}

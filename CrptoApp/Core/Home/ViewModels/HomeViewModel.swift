import Foundation
import Combine

class HomeViewModel : ObservableObject{
    
    @Published var allCoins : [CoinModel] = []
    @Published var portfolioCoins : [CoinModel] = []
    
    @Published var searchText: String = ""
    
    private let dataService = CoinDataService()
    private var cancelable = Set<AnyCancellable>()
    
    init(){
        addSubscriberes()
        
    }
    
    func addSubscriberes(){
        
        
        //Update all coins
        $searchText
            .combineLatest(dataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self ](returnedCoin) in
                self?.allCoins = returnedCoin
            }
            .store(in: &cancelable)
        
    }
    
    
    private func filterCoins(text:String,coin:[CoinModel]) -> [CoinModel]{
        
        guard !text.isEmpty else {
            return coin
        }
        
        let lowerCasedText = text.lowercased()
        
        return coin.filter { (coin) -> Bool in
            
            return coin.name.lowercased().contains(lowerCasedText) ||
            coin.symbol.lowercased().contains(lowerCasedText) ||
            coin.id.lowercased().contains(lowerCasedText)
            
        }
    }
    
}

import Foundation
import Combine

class HomeViewModel : ObservableObject{
    
    @Published var  statModel: [statisticsModel] = []
    
    
    @Published var allCoins : [CoinModel] = []
    @Published var portfolioCoins : [CoinModel] = []
    
    @Published var searchText: String = ""
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketdataService()
    private var cancelable = Set<AnyCancellable>()
    
    init(){
        addSubscriberes()
        
    }
    
    func addSubscriberes(){
        
        
        //Update all coins
        $searchText
            .combineLatest(coinDataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self ](returnedCoin) in
                self?.allCoins = returnedCoin
            }
            .store(in: &cancelable)
        
        marketDataService.$marketData
            .map { (MarketDataModel) ->[statisticsModel] in
                var stat:[statisticsModel] = []
                
                guard let data = MarketDataModel else{
                    return stat
                }
                
                let marketCap =  statisticsModel(title: "Market Cap", value:data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
                
                let volume = statisticsModel(title: "24H Volume", value: data.volume)
                
                let bitCoinDominance = statisticsModel(title: "BTC Dominance", value: data.btcDominance)
                
                let portfolio = statisticsModel(title: "Portfolio Value", value: "$ 0.0", percentageChange: 0)
                
                
                stat.append(contentsOf: [
                    
                    marketCap,
                    volume,
                    bitCoinDominance,
                    portfolio
                ])
                
                return stat
            }
            .sink {[weak self] (returnedData) in
                self?.statModel = returnedData
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
    
    private  func mapGlobalmarketData(){
        //25.26
    }
    
}

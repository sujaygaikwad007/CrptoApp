import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var statModel: [statisticsModel] = []
    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    
    @Published var searchText: String = ""
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketdataService()
    private let portFolioDataService = PortFolioDataService()
    private var cancelable = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        // Update all coins
        $searchText
            .combineLatest(coinDataService.$allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancelable)
        
        //Upadtes the market data
        marketDataService.$marketData
            .map(mapGlobalmarketData)
            .sink { [weak self] (returnedData) in
                self?.statModel = returnedData
                
            }
            .store(in: &cancelable)
        
        //Update the portFoio Coins
        $allCoins
            .combineLatest(portFolioDataService.$savedEntities)
            .map { (coinModels,portFolioEntities) ->[CoinModel] in
                coinModels
                    .compactMap { (coin)-> CoinModel? in
                        guard let entity = portFolioEntities.first(where: { $0.coinId == coin.id }) else {
                            return nil
                        }
                        return coin.updateHoldings(amount: entity.amount)
                    }
            }
            .sink { [weak self] (receivedCoins) in
                self?.portfolioCoins = receivedCoins
            }
            .store(in: &cancelable)
        
        
        
    }
    
    
    func upadatePortFolio(coin: CoinModel, amount: Double){
        portFolioDataService.updatePortFolio(coin: coin, amount: amount)
    }
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else {
            return coins
        }
        
        let lowerCasedText = text.lowercased()
        
        return coins.filter { (coin) -> Bool in
            return coin.name.lowercased().contains(lowerCasedText) ||
                   coin.symbol.lowercased().contains(lowerCasedText) ||
                   coin.id.lowercased().contains(lowerCasedText)
        }
    }
    
    private func mapGlobalmarketData(marketDataModel: MarketDataModel?) -> [statisticsModel] {
        var stat: [statisticsModel] = []
        
        guard let data = marketDataModel else {
            return stat
        }
        
        let marketCap = statisticsModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
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
}



import Foundation
import Combine

class MarketdataService {
    
    let baseUrl = "https://api.coingecko.com/api/v3/global"
    
    @Published var marketData: MarketDataModel? = nil
    var marketDataSubscription: AnyCancellable?
    
    init() {
        getMarketData()
    }
    
    private func getMarketData() {
        
        guard let url = URL(string: baseUrl) else { return }
        
        marketDataSubscription = NetworkingManager.download(url: url)
        
            .decode(type: GlobalMarketData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.habdleComplitation, receiveValue: { [weak self] (returnedGlobalData) in
                self?.marketData = returnedGlobalData.data
                self?.marketDataSubscription?.cancel()
            })
        
    }
    
    
}

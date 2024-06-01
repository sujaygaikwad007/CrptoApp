import Foundation
import Combine

class CoinDataService {
    
    let baseUrl = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h"
    
    @Published var allCoins: [CoinModel] = []
    var coinSubscription: AnyCancellable?
    
    init() {
        getCoins()
    }
    
    private func getCoins() {
        
        guard let url = URL(string: baseUrl) else { return }
        
        coinSubscription = NetworkingManager.download(url: url)
        
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.habdleComplitation, receiveValue: { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
                self?.coinSubscription?.cancel()
            })
        
    }
    
    
}

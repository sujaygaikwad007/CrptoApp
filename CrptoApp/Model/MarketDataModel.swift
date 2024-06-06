//Api Info
/*
 Url:
 https://api.coingecko.com/api/v3/global
 */



import Foundation


// MARK: - MarketDataModel
struct GlobalMarketData: Codable {
    let data: MarketDataModel?
}

// MARK: - DataClass
struct MarketDataModel: Codable {
    
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double
    
    enum CodingKeys: String, CodingKey {
        
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }
    
    var marketCap: String{
        
        if let item = totalMarketCap.first(where: {$0.key == "usd"}){
            
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var volume: String {
        if let volume = totalVolume.first(where: {$0.key == "usd"}){
            return "$" + volume.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var btcDominance:String{
        if let item = totalMarketCap.first(where: {$0.key == "btc"}){
            
            return item.value.asPercentString()
        }
        return ""
    }
}


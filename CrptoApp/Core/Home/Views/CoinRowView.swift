import SwiftUI

struct CoinRowView: View {
    
    let coin: CoinModel
    let showHoldingColumns: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            
            leftColumn
            Spacer()
            if showHoldingColumns {
                centerColumn
            }
            rightColumn
        }
        .font(.subheadline)
        
    }
}


extension CoinRowView{
    
    private var leftColumn: some View{
        HStack(spacing:0){
            
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .frame(minWidth: 30)
            
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundColor(Color.theme.accent)
        }
    }
    
    private var centerColumn : some View{
        VStack(alignment: .trailing) {
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                .bold()
            Text((coin.currentHoldings ?? 0).asNumberString())
        }
        .foregroundColor(Color.theme.accent)
    }
    
    private var rightColumn : some View{
        
        VStack(alignment: .trailing) {
            Text(coin.currentPrice?.asCurrencyWith6Decimals() ?? "$0.00")
                .bold()
                .foregroundColor(Color.theme.accent)
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "0.0")
                .foregroundColor(
                    (coin.priceChangePercentage24H ?? 0.0) >= 0 ?
                    Color.green : Color.red
                )
        }
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
        
    }
    
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            CoinRowView(coin: dev.coin, showHoldingColumns: true)
                .previewLayout(.sizeThatFits)
            
            CoinRowView(coin: dev.coin, showHoldingColumns: true)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
        
    }
}

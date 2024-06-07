import SwiftUI

struct PortFolioView: View {
    
    @EnvironmentObject private var vm : HomeViewModel
    @State private var selectedCoin : CoinModel? = nil
    @State private var quantityText = ""
    @State private var showCheckMark  = false
    
    var body: some View {
        
        NavigationView{
            
            ScrollView{
                
                VStack(alignment: .leading, spacing: 0){
                    SearchBarView(searchText: $vm.searchText)
                    coinLogoList
                    
                    if selectedCoin != nil{
                        portFolioInputSection
                    }
                    
                }
            }
            .navigationBarTitle("Edit Portfolio")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    XmarkButton()
    
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                   saveButton
                }
            })
        }
        
    }
}


extension PortFolioView{
    
    private var coinLogoList: some View{
        ScrollView(.horizontal, showsIndicators: false) {
            
            LazyHStack(spacing:10){
                ForEach(vm.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width:75)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeIn){
                                selectedCoin = coin
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == coin.id ? Color.theme.green : Color.clear,
                                        lineWidth: 1)
                        )
                    
                }
            }
            .padding(.vertical,4)
            .padding(.leading)
        }
    }
    
    private var portFolioInputSection : some View{
        VStack(spacing: 20) {
            HStack{
                Text("Current price of \( selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice?.asCurrencyWith6Decimals() ?? "")
                
            }
            Divider()
            HStack{
                Text("Amount holding:")
                Spacer()
                TextField("Ex:1.4",text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack{
                Text("Current Value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }
        .animation(.none)
        .padding()
        .font(.headline)
    }
    
    private var saveButton : some View{
        HStack(spacing:10){
            Image(systemName: "checkmark")
                .opacity(showCheckMark ? 1.0 : 0.0)
            Button {
                saveButtonPressed()
                
            } label: {
                Text("save".uppercased())

            }
            .opacity(
                selectedCoin != nil  && selectedCoin?.currentHoldings != Double(quantityText) ? 1.0 : 0.0
            )

            
        }
        .font(.headline)
    }
    
    
    private func getCurrentValue() -> Double {
        
        if let quantity = Double(quantityText){
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    private func saveButtonPressed(){
        guard let coin = selectedCoin else { return }
        //Save to portFolio
        
        //show CheckMark
        withAnimation(.easeIn) {
            showCheckMark = true
            removeSelectedCoin()
        }
        
        //hide KeyBoard
        UIApplication.shared.endEditing()
        
        //hide checkmark
        DispatchQueue.main.asyncAfter(deadline: .now()+2.0) {
            withAnimation(.easeOut) {
                showCheckMark = false
                
            }
            
        }
    }
    
    private func removeSelectedCoin(){
        selectedCoin = nil
        vm.searchText = ""
    }
    
    
}

struct PortFolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortFolioView()
            .environmentObject(dev.homeVM)
    }
}

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var showPortfolio = false //animate right
    @State private var showPortFolioView = false //new sheet
    
    var body: some View {
        ZStack{
            Color.theme.background
                .ignoresSafeArea() //bg color
            
                .sheet(isPresented: $showPortFolioView) {
                    PortFolioView()
                        .environmentObject(vm)
                }
            
            //Content
            VStack{
                homeHeader
                
                HomeStatView(showPortfolio: $showPortfolio)
                SearchBarView(searchText: $vm.searchText)
                
                columnTitles
                
                if !showPortfolio{
                    allCoinList
                        .transition(.move(edge: .leading))
               
                }
                if showPortfolio{
                    portfolioCoinList
                        .transition(.move(edge: .trailing))
                }
                
                Spacer(minLength: 0)
            }
            
        }
    }
}



extension HomeView{
    
    private var homeHeader : some View{
        HStack{
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .animation(.none)
                .onTapGesture {
                    if showPortfolio{
                        showPortFolioView.toggle()
                    }
                }
                .background(
                    CircleButtonAnimationView(animate: $showPortfolio)
                )
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(.none)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        self.showPortfolio.toggle()
                    }
                }
            
        }
        .padding(.horizontal)
    }
    
    private var allCoinList: some View{
        List{
            ForEach(vm.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingColumns: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(PlainListStyle())
        
    }
    
    
    private var portfolioCoinList: some View{
        List{
            ForEach(vm.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingColumns: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(PlainListStyle())
        
    }
    
    
    private var columnTitles : some View{
        HStack{
            Text("Coin")
            Spacer()
            if showPortfolio{
                Text("Holdings")
                
            }
          
            Text("Price")
                .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }
    
    
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            HomeView()
                .navigationBarHidden(true)
        }
        .environmentObject(dev.homeVM)
        
       
    }
}

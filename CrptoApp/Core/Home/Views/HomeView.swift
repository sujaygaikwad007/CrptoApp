import SwiftUI

struct HomeView: View {
    
    @State private var showPortfolio = false
    
    var body: some View {
        ZStack{
            Color.theme.background.ignoresSafeArea() //bg color
            
            //Content
            VStack{
                homeHeader
                
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
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            HomeView()
                .navigationBarHidden(true)
        }
        
       
    }
}

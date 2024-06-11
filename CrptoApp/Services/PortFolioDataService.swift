import Foundation
import CoreData

class PortFolioDataService{
    
    private let container:  NSPersistentContainer
    private let containerName = "PortFolioContainer"
    private let entityName = "PortFolioEntity"
    
    @Published var savedEntities: [PortFolioEntity] = []
    
    init(){
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Core Data Error-----",error)
            }
            self.getPortFolio()
        }
    }
    //MARK: Public Section
    
    func updatePortFolio(coin:CoinModel,amount:Double){
        //Check coin is alredy in portFolio
        if let entity = savedEntities.first(where: {$0.coinId == coin.id }){
            
            if amount > 0{
                update(entity: entity, amount: amount)
            } else{
                delete(entity: entity)
            }
        } else{
            add(coin: coin, amount: amount)
           
        }
        
        
    }
    
    // MARK: Private Section
    
    private func getPortFolio(){
        
        let request = NSFetchRequest<PortFolioEntity>(entityName: entityName)
        do {
           savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching entity-----",error)
        }
    }
    
    private func add(coin:CoinModel,amount:Double){
        let entity = PortFolioEntity(context: container.viewContext)
        entity.coinId = coin.id
        entity.amount = amount
        applyChange()
        
    }
    
    private func update(entity:PortFolioEntity,amount:Double){
        entity.amount = amount
        applyChange()
    }
    
    private func delete(entity:PortFolioEntity){
        container.viewContext.delete(entity)
        applyChange()
    }
    
    
    private func save(){
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error Saving to core data---",error)
        }
    }
    
    private func applyChange(){
        save()
        getPortFolio()
    }
}

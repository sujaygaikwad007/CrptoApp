
import Foundation


extension Double{
    
    
    /// Convert Double into currency 2 digit
    private var currencyFormatter2 : NumberFormatter{
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        
        //        formatter.locale = .current
        //        formatter.currencyCode = "usd"
        //        formatter.currencySymbol = "$"
        //If you want to put your currency  put here
        
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    func asCurrencyWith2Decimals()-> String{
        
        let number = NSNumber(value: self)
        return currencyFormatter2.string(from: number) ?? "$0.00"
    }
    ///
    
    /// Convert Double into currency 2-6 digit
    private var currencyFormatter6 : NumberFormatter{
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        
        //        formatter.locale = .current
        //        formatter.currencyCode = "usd"
        //        formatter.currencySymbol = "$"
        //If you want to put your currency  put here
        
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    func asCurrencyWith6Decimals()-> String{
        
        let number = NSNumber(value: self)
        return currencyFormatter6.string(from: number) ?? "$0.00"
    }
    ///
    
    
    
    func asNumberString()-> String{
        return String(format: "%.2f", self)
        
    }
    
    func asPercentString()-> String{
        return asNumberString() + "%"
    }
}

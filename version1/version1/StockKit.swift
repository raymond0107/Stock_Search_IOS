import Foundation
import Alamofire
import CoreData

struct StockCandidate {
    var symbol: String?
    var name: String?
    var exchange: String?
}

struct StockDetails {
    var name: String?
    var symbol: String?
    var last_price: Double?
    var change: Double?
    var changePercent: Double?
    var time_and_date: String?
    var market_cap: Double?
    var volume: Double?
    var changeYTD: Double?
    var changeYTDPercent: Double?
    var high_price: Double?
    var low_price: Double?
    var open_price: Double?
}

struct StockNews {
    var title: String?
    var content: String?
    var publisher: String?
    var date: String?
    var url: String?
}

class StockKit {
    
    class func  fetchStocksInput (name:String, completion:(stockCandidateArray: [StockCandidate]) -> ()) {
        var stockCandidateArray = [StockCandidate]()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            Alamofire.request(.GET, "http://csci571-1272.appspot.com/?", parameters: ["find":name])
                .responseJSON { response in
                    if let JSON = response.result.value {
                        if (JSON.count > 0) {
                            for s in JSON as! [NSDictionary]{
                                let symbol = s["Symbol"] as! String
                                let name = s["Name"] as! String
                                let exchange = s["Exchange"] as! String
                                stockCandidateArray.append(StockCandidate(symbol: symbol, name: name, exchange: exchange))
                            }

                        }
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(stockCandidateArray: stockCandidateArray)
                    }
            }
        }
    }
    
    class func  fetchStocksSymbol (name:String, completion:(stockDetailsArray: [StockDetails]) -> ()) {
        var stockDetailsArray = [StockDetails]()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            Alamofire.request(.GET, "http://csci571-1272.appspot.com/?", parameters: ["symbol":name])
                .responseJSON { response in
                    if let s = response.result.value {
                        if (s.count > 0) {
                                if (s["Status"] as! String == "SUCCESS") {
                                    let name = s["Name"] as! String
                                    let symbol = s["Symbol"] as! String
                                    let change = s["Change"] as! Double
                                    let last_price = s["LastPrice"] as! Double
                                    let changePercent = s["ChangePercent"] as! Double
                                    let time_and_date = s["Timestamp"] as! String
                                    let market_cap = s["MarketCap"] as! Double
                                    let volume = s["Volume"] as! Double
                                    let changeYTD = s["ChangeYTD"] as! Double
                                    let changeYTDPercent = s["ChangePercentYTD"] as! Double
                                    let high_price = s["High"] as! Double
                                    let low_price = s["Low"] as! Double
                                    let open_price = s["Open"] as! Double
                                    stockDetailsArray.append(StockDetails(name: name, symbol: symbol, last_price: last_price, change: change, changePercent: changePercent,time_and_date: time_and_date, market_cap: market_cap, volume: volume, changeYTD: changeYTD, changeYTDPercent: changeYTDPercent,high_price: high_price, low_price: low_price, open_price: open_price))
                                }
                        }
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(stockDetailsArray: stockDetailsArray)
                    }
            }
        }
    }
    
    class func  fetchStocksNews (name:String, completion:(stockNewsArray: [StockNews]) -> ()) {
        var stockNewsArray = [StockNews]()
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            Alamofire.request(.GET, "http://stock-search-20161.appspot.com/myphp.php", parameters: ["newsfeed":name])
                .responseJSON { response in
                    if let JSON = response.result.value {
                        for s in JSON["d"]!!["results"] as! [NSDictionary] {
                            let title = s["Title"] as! String
                            let content = s["Description"] as! String
                            let publisher = s["Source"] as! String
                            let date = s["Date"] as! String
                            let url = s["Url"] as! String
                            stockNewsArray.append(StockNews(title: title, content: content, publisher: publisher, date: date, url: url))
                        }
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        completion(stockNewsArray: stockNewsArray)
                    }
            }
        }
    }
}
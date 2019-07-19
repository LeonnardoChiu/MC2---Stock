//
//  BlueChipViewController.swift
//  MC2
//
//  Created by Linando Saputra on 15/07/19.
//  Copyright © 2019 Linando Saputra. All rights reserved.
//

import UIKit

class BlueChipController: UIViewController {
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var blueChipTableView: UITableView!
    var titlePage = ""
    var money: Float = 0
    var jsonCounter = 98
    var stockPercentage: Float = 0
    var sortedStock: [TimeSeries.StockDate] = []
    var blueChipPrice: [Float] = []
    var blueChipPercentage: [Float] = []
    var midCapPrice: [Float] = []
    var midCapPercentage: [Float] = []
    var pennyStockPrice: [Float] = []
    var pennyStockPercentage: [Float] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        blueChipTableView.tableFooterView = UIView()
        let date = Date()
        let calendar = Calendar.current
        if(UserDefaults.standard.object(forKey: "lastLoginDate") != nil)
        {
            let dateStart = calendar.startOfDay(for: UserDefaults.standard.object(forKey: "lastLoginDate") as! Date)
            let dateEnd = calendar.startOfDay(for: date)
            
            let differenceInDay = calendar.dateComponents([.day], from: dateStart, to: dateEnd).day
            if(date != (UserDefaults.standard.object(forKey: "lastLoginDate") as! Date))
            {
                jsonCounter -= differenceInDay!
            }
        }
        UserDefaults.standard.set(date, forKey: "lastLoginDate")
        self.title = titlePage
        if self.title == "Blue Chip"{
            descriptionLabel.text = "Blue chip : denoting companies or their shares considered to be a reliable investment, though less secure than gilt-edged stock."
        }else if self.title == "Mid-Cap"{
            descriptionLabel.text = "Mid-cap is the term given to companies with a market capitalization (value) between $150 and $800 million."
        }else if self.title == "Penny Stock"{
            descriptionLabel.text = "Penny stock : a common stock valued at less than one dollar, and therefore highly speculative."
        }
    
        
    }
    
}

extension BlueChipController: UITableViewDelegate, UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BlueChipCell") as! BlueChipCell
        
        if titlePage == "Blue Chip" {
            do{
                let decodedBlueChip = try JSONDecoder().decode(Stock.self, from: blueChipJSON[indexPath.row])
                sortedStock = decodedBlueChip.timeSeries.stockDates.sorted(by: { $0.date > $1.date })
                cell.stockSymbol.text = blueChipSymbol[indexPath.row]
                blueChipPrice.append(Float(sortedStock[jsonCounter].open)!)
                stockPercentage = (Float(sortedStock[jsonCounter].open)! - Float(sortedStock[jsonCounter+1].open)!) * 100 / Float(sortedStock[jsonCounter+1].open)!
                blueChipPercentage.append(stockPercentage)
                
            } catch let jsonErr{
                print("Error serializing json: ", jsonErr)
            }
        }
        else if titlePage == "Mid-Cap"
        {
            do{
                let decodedMidCap = try JSONDecoder().decode(Stock.self, from: midCapJSON[indexPath.row])
                sortedStock = decodedMidCap.timeSeries.stockDates.sorted(by: { $0.date > $1.date })
                cell.stockSymbol.text = midCapSymbol[indexPath.row]
                midCapPrice.append(Float(sortedStock[jsonCounter].open)!)
                stockPercentage = (Float(sortedStock[jsonCounter].open)! - Float(sortedStock[jsonCounter+1].open)!) * 100 / Float(sortedStock[jsonCounter+1].open)!
                midCapPercentage.append(stockPercentage)
            } catch let jsonErr{
                print("Error serializing json: ", jsonErr)
            }

        }
        else if titlePage == "Penny Stock"
        {
            do{
                let decodedPennyStock = try JSONDecoder().decode(Stock.self, from: pennyStockJSON[indexPath.row])
                sortedStock = decodedPennyStock.timeSeries.stockDates.sorted(by: { $0.date > $1.date })
                cell.stockSymbol.text = pennyStockSymbol[indexPath.row]
                pennyStockPrice.append(Float(sortedStock[jsonCounter].open)!)
                stockPercentage = (Float(sortedStock[jsonCounter].open)! - Float(sortedStock[jsonCounter+1].open)!) * 100 / Float(sortedStock[jsonCounter+1].open)!
                pennyStockPercentage.append(stockPercentage)
                
            } catch let jsonErr{
                print("Error serializing json: ", jsonErr)
            }
            
        }
        cell.stockPrice.text = String(format: "%.2f", (Float(sortedStock[jsonCounter].open)!))
        
        if(stockPercentage > 0)
        {
            cell.stockChange.text = String(format: "+%.2f%%", stockPercentage)
            cell.stockChange.textColor = .init(red: 0, green: 0.9, blue: 0, alpha: 1)
            //cell.stockChange.font = UIFont.boldSystemFont(ofSize: 17)
        }
        else
        {
            cell.stockChange.text = String(format: "%.2f%%", stockPercentage)
            cell.stockChange.textColor = .red
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var vc = storyboard?.instantiateViewController(withIdentifier: "TableDetailViewController") as? TableDetailViewController
        if self.title == "Blue Chip"{
            vc?.stockName = blueChipSymbol[indexPath.row]
            vc?.stockPrice = blueChipPrice[indexPath.row]
            vc?.stockPercentage = blueChipPercentage[indexPath.row]
            vc!.money = UserDefaults.standard.float(forKey: "balance")
            self.navigationController?.pushViewController(vc!, animated: true)
        }else if self.title == "Mid-Cap"{
            vc?.stockName = midCapSymbol[indexPath.row]
            vc?.stockPrice = midCapPrice[indexPath.row]
            vc?.stockPercentage = midCapPercentage[indexPath.row]
            vc!.money = UserDefaults.standard.float(forKey: "balance")
            self.navigationController?.pushViewController(vc!, animated: true)
        }else if self.title == "Penny Stock"{
            vc?.stockName = pennyStockSymbol[indexPath.row]
            vc?.stockPrice = pennyStockPrice[indexPath.row]
            vc?.stockPercentage = pennyStockPercentage[indexPath.row]
            vc!.money = UserDefaults.standard.float(forKey: "balance")
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        
    }
}

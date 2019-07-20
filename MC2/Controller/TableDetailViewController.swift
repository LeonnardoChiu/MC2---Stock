//
//  TableDetailViewController.swift
//  MC2
//
//  Created by Evan Christian on 16/07/19.
//  Copyright © 2019 Linando Saputra. All rights reserved.
//

import UIKit
import CoreData

class TableDetailViewController: UIViewController, UITextFieldDelegate {
    let date = Date()
    let format = DateFormatter()
    var stockTransaction = [Transaction]()
    

    
    @IBOutlet weak var stockNameLabel: UILabel!
    @IBOutlet weak var stockPriceLabel: UILabel!
    @IBOutlet weak var stockChangeLabel: UILabel!
    @IBOutlet weak var totalBalanceLabel: UILabel!
    @IBOutlet weak var stockNameSellLabel: UILabel!
    @IBOutlet weak var stockAmountLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var sellButton: UIButton!
    @IBOutlet weak var buyAmountTextField: UITextField!
    @IBOutlet weak var sellAmountTextField: UITextField!
    var money: Float = 0
    var stockName = ""
    var stockPrice:Float = 0
    var stockPercentage:Float = 0
    
    //LINE CHART Variables
    @IBOutlet weak var day1: UILabel!
    @IBOutlet weak var day2: UILabel!
    @IBOutlet weak var day3: UILabel!
    @IBOutlet weak var day4: UILabel!
    @IBOutlet weak var day5: UILabel!
    @IBOutlet weak var day6: UILabel!
    @IBOutlet weak var price1: UILabel!
    @IBOutlet weak var price2: UILabel!
    @IBOutlet weak var price3: UILabel!
    @IBOutlet weak var price4: UILabel!
    @IBOutlet weak var chartView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        var jsonForChart: Int
        if(blueChipSymbol.firstIndex(of: stockName) != nil)
        {
            jsonForChart = blueChipSymbol.firstIndex(of: stockName)!
        }
        else if(midCapSymbol.firstIndex(of: stockName) != nil)
        {
            jsonForChart = midCapSymbol.firstIndex(of: stockName)!
        }
        else
        {
            jsonForChart = pennyStockSymbol.firstIndex(of: stockName)!
        }
        var harga: [Float] = []
        var sortedStock: [TimeSeries.StockDate] = []
        do {
            let decodedStock = try JSONDecoder().decode(Stock.self, from: blueChipJSON[jsonForChart])
            sortedStock = decodedStock.timeSeries  .stockDates.sorted(by: { $0.date < $1.date })
        } catch {
            print("Fail to get API")
        }
        for i in 0...5 {
            harga.append(Float(sortedStock[i].open)!)
            print(harga[i])
            //ratio += harga[i]
        }
        let maxHarga = harga.max()!
        let minHarga = harga.min()!
        
        
        print("MAx = \(maxHarga)")
        prepareLineChart(max: Float(maxHarga), min: Float(minHarga))
        
        var pointCoor: [Float] = []
        var xStartPoint = 90
        for i in 0...5 {
            var getCoor:Float = 0
            if (maxHarga == harga[i])
            {
                getCoor = 40
            }
            else
            if (minHarga == harga[i])
            {
                getCoor = 130
            }
            else if(harga[i] > (maxHarga + minHarga) / 2)
            {
                //getCoor = 85 - (harga[i] / ratio * 90)
                getCoor = (maxHarga - harga[i]) * 90 / (maxHarga - minHarga) + 40
            }
            else if(harga[i] < (maxHarga + minHarga) / 2)
            {
                getCoor = (maxHarga - harga[i]) * 90 / (maxHarga - minHarga) + 40
            }
            if getCoor > 160 {
                getCoor = 160
            }
            pointCoor.append(getCoor)
            generateCircle(xPoint: xStartPoint, yPoint: Int(pointCoor[i]))
            if i > 0{
                drawLineFromPoint(start: CGPoint(x: xStartPoint-50, y: Int(pointCoor[i-1])), toPoint: CGPoint(x: xStartPoint, y: Int(pointCoor[i])), ofColor: UIColor.init(displayP3Red: 242, green: 170, blue: 76, alpha: 1), inView: chartView)
            }
            xStartPoint = xStartPoint + 50
            print("Koor ke \(i) = \(pointCoor[i])")
        }
    }
    
    func prepareLineChart(max: Float, min: Float) {
        let currentDate = Calendar.current.component(.day, from: date)
        let getDay = Int(currentDate)
        day1.text = String(getDay-1)
        day2.text = String(getDay-2)
        day3.text = String(getDay-3)
        day4.text = String(getDay-4)
        day5.text = String(getDay-5)
        day6.text = String(getDay-6)
        
        var price = max
        price1.text = String(format: "%.2f", price)
        price = min + (((max - min) / 3) * 2)
        price2.text = String(format: "%.2f", price)
        price = min + ((max - min) / 3)
        price3.text = String(format: "%.2f", price)
        price = min
        price4.text = String(format: "%.2f", price)
        
    }
    
    func generateCircle(xPoint: Int, yPoint: Int) {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: xPoint, y: yPoint), radius: 5, startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = #colorLiteral(red: 0.9987228513, green: 0.6511953473, blue: 0.1908171773, alpha: 1)
        shapeLayer.strokeColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        shapeLayer.lineWidth = 0.5
        chartView.layer.addSublayer(shapeLayer)
        
    }
    
    func drawLineFromPoint(start : CGPoint, toPoint end:CGPoint, ofColor lineColor: UIColor, inView view:UIView) {
        
        //design the path
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        
        //design path in layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = 1.0
        
        view.layer.addSublayer(shapeLayer)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        buyAmountTextField.delegate = self
        sellAmountTextField.delegate = self
        tableView.tableFooterView = UIView()
        buyAmountTextField.keyboardType = UIKeyboardType.numberPad
        sellAmountTextField.keyboardType = UIKeyboardType.numberPad
        totalBalanceLabel.text = "\(money)"
        stockNameLabel.text = stockName
        stockPriceLabel.text = "\(stockPrice)"
        if(stockPercentage > 0)
        {
            stockChangeLabel.text = String(format: "+%.2f%%", stockPercentage)
        }
        else
        {
            stockChangeLabel.text = String(format: "%.2f%%", stockPercentage)
        }
        
        stockNameSellLabel.text = stockName
        
        buyButton.isEnabled = false
        buyButton.alpha = 0.8
        sellButton.isEnabled = false
        sellButton.alpha = 0.8
        
        if(stockPercentage > 0)
        {
            stockChangeLabel.textColor = .init(red: 0, green: 0.9, blue: 0, alpha: 1)
        }
        else
        {
            stockChangeLabel.textColor = .red
        }
        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        let managedContext = appDelegate?.persistentContainer.viewContext
        
        //2
        var transactions = [Transaction]()
        
        
        do {
            transactions = try managedContext!.fetch(Transaction.fetchRequest())
            var indexCounter = 0
            var stockAmount: Int64 = 0
            for transaction in transactions{
                if transaction.name == stockName
                {
                    stockTransaction.append(transaction)
                    indexCounter+=1
                    if(transaction.type == "Buy")
                    {
                        stockAmount += transaction.amount
                    }
                    else
                    {
                        stockAmount -= transaction.amount
                    }
                }
            }
            stockAmountLabel.text = "\(stockAmount)"
        } catch  {
            print("Gagal Memanggil")
        }
    }
    
    //LINE CHART END HERE ...............
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func buyButtonTapped(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        let transaction = Transaction(context: managedContext)
        
        transaction.name = stockName
        transaction.price = stockPrice
        transaction.amount = Int64(buyAmountTextField.text!)!
        transaction.date = Date()
        transaction.type = "Buy"
        
        
        print(transaction.price)
        
        money -= Float(transaction.amount) * Float(transaction.price)
        totalBalanceLabel.text = "\(money)"
        UserDefaults.standard.set(Float(totalBalanceLabel.text!)!, forKey: "balance")
        
        buyAmountTextField.text = ""
        buyButton.isEnabled = false
        buyButton.alpha = 0.8
        
        
        
        var stockAmount: Int64 = 0
        for amountTransaction in stockTransaction
        {
            if(amountTransaction.type == "Buy")
            {
                stockAmount += amountTransaction.amount
            }
            else
            {
                stockAmount -= amountTransaction.amount
            }
        }
        stockAmount += transaction.amount
        stockAmountLabel.text = "\(stockAmount)"
        
        do {
            try managedContext.save()
            stockTransaction.append(transaction)
            tableView.insertRows(at: [IndexPath(row: stockTransaction.count-1, section: 0)], with: .automatic)
        } catch  {
            print("gagal menyimpan")
        }
    }
    
     @IBAction func sellButtonTapped(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {return}
        
        let transaction = Transaction(context: managedContext)
        
        transaction.name = stockName
        transaction.price = stockPrice
        transaction.amount = Int64(sellAmountTextField.text!)!
        transaction.date = Date()
        transaction.type = "Sell"
        
        money += Float(transaction.amount) * Float(transaction.price)
        totalBalanceLabel.text = "\(money)"
        UserDefaults.standard.set(Float(totalBalanceLabel.text!)!, forKey: "balance")
        
        sellAmountTextField.text = ""
        sellButton.isEnabled = false
        sellButton.alpha = 0.8
        
        var stockAmount: Int64 = 0
        for amountTransaction in stockTransaction
        {
            if(amountTransaction.type == "Buy")
            {
                stockAmount += amountTransaction.amount
            }
            else
            {
                stockAmount -= amountTransaction.amount
            }
            
        }
        stockAmount -= transaction.amount
        stockAmountLabel.text = "\(stockAmount)"
        if stockAmount == 0{
            //klo stocknya 0 di delete di core data
            
        }
        do {
            try managedContext.save()
            stockTransaction.append(transaction)
            tableView.insertRows(at: [IndexPath(row: stockTransaction.count-1, section: 0)], with: .automatic)
        } catch  {
            print("gagal menyimpan")
        }
        print()
     }
    @IBAction func buyTextFieldEditingChanged(_ sender: Any) {
        buyButton.isEnabled = true
        buyButton.alpha = 1
        
        if (Float(buyAmountTextField.text!) ?? 0) * stockPrice >= Float(totalBalanceLabel.text!)!{
            buyAmountTextField.text = "\(Int(Float(totalBalanceLabel.text!)! / stockPrice))"
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        }
        
    }
    @IBAction func sellTextFieldEditingChanged(_ sender: Any) {
        sellButton.isEnabled = true
        sellButton.alpha = 1
        
        if (Float(sellAmountTextField.text!) ?? 0) >= Float(stockAmountLabel.text!)!
        {
            sellAmountTextField.text = stockAmountLabel.text
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        }
    }
    
    
    
}


extension TableDetailViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stockTransaction.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell") as! TransactionCell
        format.dateFormat = "yyyy-MM-dd"
        let formattedDate = format.string(from: date)
        
        cell.dateLabel.text = formattedDate
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.typeLabel.text = stockTransaction[indexPath.row].type
        cell.priceLabel.text = String(format: "%.2f", stockTransaction[indexPath.row].price)
        cell.amountLabel.text = "\(stockTransaction[indexPath.row].amount)"
        
        return cell
    }
    
}

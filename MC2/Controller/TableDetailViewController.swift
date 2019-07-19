//
//  TableDetailViewController.swift
//  MC2
//
//  Created by Evan Christian on 16/07/19.
//  Copyright © 2019 Linando Saputra. All rights reserved.
//

import UIKit
import CoreData

class TableDetailViewController: UIViewController {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        cell.typeLabel.text = stockTransaction[indexPath.row].type
        cell.priceLabel.text = String(format: "+%.2f", stockTransaction[indexPath.row].price)
        cell.amountLabel.text = "\(stockTransaction[indexPath.row].amount)"
        
        return cell
    }
    
}

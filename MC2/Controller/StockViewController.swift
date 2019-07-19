//
//  StockViewController.swift
//  MC2
//
//  Created by Evan Christian on 12/07/19.
//  Copyright © 2019 Linando Saputra. All rights reserved.
//

import UIKit


class StockViewController: UIViewController {

    @IBOutlet weak var blueChipImageView: UIImageView!
    @IBOutlet weak var midCapImageView: UIImageView!
    @IBOutlet weak var pennyStockImageView: UIImageView!
    @IBOutlet weak var balanceTotalLabel: UILabel!
    @IBOutlet weak var blueChipButton: UIButton!
    @IBOutlet weak var midCapButton: UIButton!
    @IBOutlet weak var pennyStockButton: UIButton!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let date = Date()
        let calendar = Calendar.current
        if(UserDefaults.standard.object(forKey: "lastLoginDate") != nil)
        {
            let dateStart = calendar.startOfDay(for: UserDefaults.standard.object(forKey: "lastLoginDate") as! Date)
        }
        UserDefaults.standard.set(date, forKey: "lastLoginDate")
        let balance = UserDefaults.standard.float(forKey: "balance")
        if balance > 0{
            
            balanceTotalLabel.text = "\(balance)"
        }else{
            balanceTotalLabel.text = "0"
        }
        
        let tapBlueChip = UITapGestureRecognizer(target: self, action: #selector(tappedBlueChip(_:)))
        blueChipImageView.addGestureRecognizer(tapBlueChip)
        blueChipImageView.isUserInteractionEnabled = true
        
        let tapMidCap = UITapGestureRecognizer(target: self, action: #selector(tappedMidCap(_:)))
        midCapImageView.addGestureRecognizer(tapMidCap)
        midCapImageView.isUserInteractionEnabled = true
        
        let tapPennyStock = UITapGestureRecognizer(target: self, action: #selector(tappedPennyStock(_:)))
        pennyStockImageView.addGestureRecognizer(tapPennyStock)
        pennyStockImageView.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
    }
    
    @objc func tappedBlueChip(_ sender: Any)
    {
        self.performSegue(withIdentifier: "blueChipSegue", sender: "")
    }
    
    @objc func tappedMidCap(_ sender: Any)
    {
        self.performSegue(withIdentifier: "midCapSegue", sender: "")
    }
    
    @objc func tappedPennyStock(_ sender: Any)
    {
        self.performSegue(withIdentifier: "pennyStockSegue", sender: "")
    }

    @IBAction func blueChipButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "blueChipSegue", sender: "")
    }
    @IBAction func midCapButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "midCapSegue", sender: "")
    }
    @IBAction func pennyStockButtonTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "pennyStockSegue", sender: "")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "blueChipSegue"{
            var vc = segue.destination as! BlueChipController
            vc.titlePage = self.blueChipButton.titleLabel?.text! ?? ""
            vc.money = Float(balanceTotalLabel.text!)!
        }else if segue.identifier == "midCapSegue"{
            var vc = segue.destination as! BlueChipController
            vc.titlePage = self.midCapButton.titleLabel?.text! ?? ""
            vc.money = Float(balanceTotalLabel.text!)!
        }else if segue.identifier == "pennyStockSegue"{
            var vc = segue.destination as! BlueChipController
            vc.titlePage = self.pennyStockButton.titleLabel?.text! ?? ""
            vc.money = Float(balanceTotalLabel.text!)!
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

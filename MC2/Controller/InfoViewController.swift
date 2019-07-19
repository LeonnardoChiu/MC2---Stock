//
//  InfoViewController.swift
//  MC2
//
//  Created by Louis  Valen on 19/07/19.
//  Copyright © 2019 Linando Saputra. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var Uiviews: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        Uiviews.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        // Do any additional setup after loading the view.
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.removeFromSuperview()
        print("ketap")
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

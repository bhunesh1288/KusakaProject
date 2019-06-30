//
//  GotoOrdersVC.swift
//  KUSAKA
//
//  Created by Rahul Mishra on 29/08/18.
//  Copyright © 2018 Rahul Mishra. All rights reserved.
//

import UIKit

class GotoOrdersVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    //****************************************************
    // MARK: - Custom Method
    //****************************************************
    
    //****************************************************
    // MARK: - API Methods
    //****************************************************
    
    //****************************************************
    // MARK: - Action Method
    //****************************************************
    @IBAction func gotoorder_Action(_ sender: Any)
    {
        let OrdersVC = self.storyboard?.instantiateViewController(withIdentifier: "OrdersVC")
        self.navigationController?.pushViewController(OrdersVC!, animated: false)
        
    }
    
    
    
    
    //****************************************************
    // MARK: - Memory CleanUP
    //****************************************************
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

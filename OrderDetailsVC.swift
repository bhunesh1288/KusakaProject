//
//  OrderDetailsVC.swift
//  KUSAKA
//
//  Created by Rahul Mishra on 29/08/18.
//  Copyright © 2018 Rahul Mishra. All rights reserved.
//

import UIKit

class OrderDetailsVC: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var img_cart: UIImageView!
    @IBOutlet weak var lbl_countcart: UILabel!
     @IBOutlet weak var btn_Header: UIButton!
    @IBOutlet weak var tbl_Cart: UITableView!
    var arrayOrders =  [[String:Any]]()
     var price = Float()
    var order_detail = [String:Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let headertitle = "Order ID: " + order_ID
        btn_Header.setTitle(headertitle, for: .normal)
        
        
        self.getOrderList()
//        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
//        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
//            statusBar.backgroundColor = UIColor.black
//        }
//        UIApplication.shared.statusBarStyle = .lightContent
//        UINavigationBar.appearance().clipsToBounds = true
//        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
//        statusBar.backgroundColor = UIColor.black
        
        // self.navigationController?.isNavigationBarHidden = true
        tbl_Cart.tableFooterView = UIView()
        // self.tbl_Cart.addSubview(view_total)
        
//        img_cart.layer.cornerRadius = img_cart.layer.frame.height/2
//        img_cart.layer.borderWidth = 1
//        img_cart.layer.borderColor = (UIColor .init(red: 189.0/255.0, green: 89.0/255.0, blue: 49.0/255.0, alpha: 1)).cgColor
        // Do any additional setup after loading the view.
    }
    //****************************************************
    // MARK: - Custom Method
    //****************************************************
    
    //****************************************************
    // MARK: - API Methods
    //****************************************************
    func getOrderList() {
        let setparameters = ["access_token":UserModel.sharedInstance.auth_Key] as [String : Any]
        print(setparameters)
      //  let str_FullUrl = "user/orders"+"?access_token=\(UserModel.sharedInstance.auth_Key)"
        let str_FullUrl = "user/order-detail"+"?access_token=\(UserModel.sharedInstance.auth_Key)"+"&order_id=\(order_ID)"
        print("str_FullUrl is:-",str_FullUrl)
        
        AutoBcmLoadingView.show("Loading......")
        AppHelperModel.requestPOSTURL(str_FullUrl, params: setparameters as [String : AnyObject],headers: nil,
                                      success: { (respose) in
                                        AutoBcmLoadingView.dismiss()
                                        let tempDict = respose as! NSDictionary
                                        print(tempDict)
                                        
                                        let lStatus = tempDict.value(forKey: "success") as! Bool
                                        
                                        if lStatus == true {
                                            
                                            let dict_Data = tempDict["data"] as! NSDictionary
                                            print("dict_Data is:-",dict_Data)
                                            
                                        //    dict_Data["delivery_menu"] as! [String:Any]
                                            
                                            self.order_detail = dict_Data["order_detail"] as! [String:Any]
                                            print("order_detail is:-",self.order_detail)
                                            
                                            self.arrayOrders = dict_Data["order_item"] as! [[String:Any]]
                                            
                                            self.tbl_Cart.reloadData()
                                            
                                            
                                            
                                            
                                        }else{
                                            // Somethign wrong
                                            
                                        }
                                        
                                        
        }) { (error) in
            print(error.localizedDescription)
            CommenModel.showDefaltAlret(strMessage:error.localizedDescription, controller: self)
            AutoBcmLoadingView.dismiss()
        }
    }
    
    
    
    
    //****************************************************
    // MARK: - Action Method
    //****************************************************
   
    @IBAction func orders_Action(_ sender: Any)
    {
         self.dismiss(animated: true, completion: nil)
    }
    
    //    MARK:- tableView's methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0
            
        {
            return 84
            
        }
        else
            
        {
            return 113
            
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if section==0
            
        {
            return self.arrayOrders.count
            
        }
        else
            
        {
            return 1
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0
        {
            let cell_Add = tableView.dequeueReusableCell(withIdentifier: "CartListCell", for: indexPath) as! CartListCell
            cell_Add.img_order.layer.cornerRadius = cell_Add.img_order.layer.frame.height/2
            cell_Add.img_order.clipsToBounds = true
            
          //  price =  arrayOrders[indexPath.row]["order_price"] as! Float
            price = Float(truncating:self.arrayOrders[indexPath.row]["total_amount"] as! NSNumber)
            let price1 = String(price)
            
            
            
            cell_Add.lbl_dishname.text = arrayOrders[indexPath.row]["order_title"] as? String
           // cell_Add.lbl_quantity.text  =   "GH₵ " + price1
            
          cell_Add.lbl_quantity.text = "GH₵ \(Float(truncating:self.arrayOrders[indexPath.row]["order_price"] as! NSNumber)) * \(self.arrayOrders[indexPath.row]["quantity"] as! Int)"
            
            cell_Add.lbl_price.text  =   "GH₵ " + price1
            cell_Add.lbl_description.text = arrayOrders[indexPath.row]["description"] as? String
            
            return cell_Add
        }
        else
        {
            
            let cell_Add1 = tableView.dequeueReusableCell(withIdentifier: "CartTotalCell", for: indexPath) as! CartTotalCell
            cell_Add1.lbl_processing.layer.cornerRadius = cell_Add1.lbl_processing.layer.frame.height/2
            cell_Add1.lbl_processing.clipsToBounds = true
            
            
            if self.order_detail.count > 0
            {
            
           // let cart_subtotal  =  self.order_detail["cart_subtotal"] as! Float
            let cart_subtotal  = Float(truncating:self.order_detail["cart_subtotal"] as! NSNumber)
                
            let cart_subtotal1 = String(cart_subtotal)
            cell_Add1.lbl_cartsubtotal.text  =  "GH₵ " + cart_subtotal1
            cell_Add1.lbl_shipping.text =  self.order_detail["shipping"] as? String
            cell_Add1.lbl_processing.text = self.order_detail["order_status"] as? String
        //    let order_total  =  self.order_detail["order_total"] as! Float
                
             let order_total  = Float(truncating:self.order_detail["order_total"] as! NSNumber)
            let order_total1 = String(order_total)
            cell_Add1.lbl_ordertotal.text  =  "GH₵ " + order_total1
            
            let str_orderstatus=self.order_detail["order_status"] as? String
            if str_orderstatus == "Pending"
            {
                cell_Add1.lbl_processing.backgroundColor = UIColor(red: 216.0/255.0, green: 157.0/255.0, blue: 55.0/255.0, alpha: 1)
            }
            else if str_orderstatus == "Processing"
                
            {
                cell_Add1.lbl_processing.backgroundColor = UIColor(red: 216.0/255.0, green: 157.0/255.0, blue: 55.0/255.0, alpha: 1)
            }
            else if str_orderstatus == "Cancel"
            {
                cell_Add1.lbl_processing.backgroundColor = UIColor(red: 224.0/255.0, green: 0.0/255.0, blue: 25.0/255.0, alpha: 1)
            }
            else
            {
                cell_Add1.lbl_processing.backgroundColor = UIColor(red: 80.0/255.0, green: 145.0/255.0, blue: 58.0/255.0, alpha: 1)
            }
            
            }
            return cell_Add1
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        //        stringPassed = (self.arr_NewsListALT[indexPath.row]["description"] as? String)!
        //        stringPasseddate = (self.arr_NewsListALT[indexPath.row]["created_at"] as? String)!
        //        ImagePassed = (self.arr_NewsListALT[indexPath.row]["news_image"] as? String)!
        //
        //        let newsdetails_ViewController = self.storyboard?.instantiateViewController(withIdentifier: "NewsDetails_VC")
        //
        //
        //        self.navigationController?.pushViewController(newsdetails_ViewController!, animated: true)
        
    }
    
    //****************************************************
    // MARK: - Memory CleanUP
    //****************************************************
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

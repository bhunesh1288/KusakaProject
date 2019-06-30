//
//  OrdersVC.swift
//  KUSAKA
//
//  Created by Rahul Mishra on 29/08/18.
//  Copyright © 2018 Rahul Mishra. All rights reserved.
//

import UIKit

var order_total_price = Float()
var total_item = Int()
var order_ID = ""

class OrdersVC: UIViewController, UITableViewDataSource,UITableViewDelegate {

    var tempArr = NSMutableArray()
    @IBOutlet weak var img_cart: UIImageView!
    @IBOutlet weak var lbl_countcart: UILabel!
    @IBOutlet weak var tbl_Order: UITableView!
    @IBOutlet weak var view_tab: UIView!
   
    var arrayOrders =  [[String:Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
   
        
        if UserDefaults.standard.object(forKey: "highscore") != nil
        {
            
            self.lbl_countcart.text = UserDefaults.standard.value(forKey: "highscore") as? String
        }
        else
        {
            
        
        }

        view_tab.layer.shadowColor = UIColor.lightGray.cgColor
        view_tab.layer.shadowOpacity = 5.0
        view_tab.layer.shadowRadius = 5.0
        view_tab.layer.shadowOffset = CGSize (width: 1.5, height: 1.5)
        view_tab.layer.masksToBounds = false
        view_tab.layer.cornerRadius = 5.0
        
        if (UserDefaults.standard.value(forKey: "isLogin") as? Data) != nil
        {
             self.getOrderList()
        }
        else
        {
           
        }
        
       
        
//        UINavigationBar.appearance().clipsToBounds = true
//        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
//        statusBar.backgroundColor = UIColor.black
        
//        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
//        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
//            statusBar.backgroundColor = UIColor.black
//        }
//        UIApplication.shared.statusBarStyle = .lightContent
        
        
       //  self.navigationController?.isNavigationBarHidden = true
         tbl_Order.tableFooterView = UIView()
        img_cart.layer.cornerRadius = img_cart.layer.frame.height/2
        img_cart.layer.borderWidth = 1
        img_cart.layer.borderColor = (UIColor .init(red: 189.0/255.0, green: 89.0/255.0, blue: 49.0/255.0, alpha: 1)).cgColor
        img_cart.clipsToBounds = true
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
       let str_FullUrl = "user/orders"+"?access_token=\(UserModel.sharedInstance.auth_Key)"
       //  let str_FullUrl = "user/orders"+"?access_token=\("71442ee5cb13f00a184d5cd902f5758f")"
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
                                            
//                                            let delivery_menu = dict_Data["delivery_menu"] as! NSDictionary
//                                            print("delivery_menu is:-",delivery_menu)
                                            
                                            self.arrayOrders = dict_Data["orders"] as! [[String:Any]]
                                            
                                            self.tbl_Order.reloadData()
                                            
                                            
                                          
                                            
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
    @IBAction func menu_Action(_ sender: Any)
    {
        let DashboardVC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC")
        self.navigationController?.pushViewController(DashboardVC!, animated: false)
    }
    @IBAction func cart_Action(_ sender: Any)
    {
//        let CartVC = self.storyboard?.instantiateViewController(withIdentifier: "CartVC")
//        self.navigationController?.pushViewController(CartVC!, animated: false)
        
        let CartVC = self.storyboard?.instantiateViewController(withIdentifier: "CartVC") as! CartVC
        CartVC.tempArr = self.tempArr
        
        self.navigationController?.pushViewController(CartVC, animated: false)
    }
  
    @IBAction func account_Action(_ sender: Any)
    {
//        let AccountVC = self.storyboard?.instantiateViewController(withIdentifier: "AccountVC")
//        self.navigationController?.pushViewController(AccountVC!, animated: false)
        
        let AccountVC = self.storyboard?.instantiateViewController(withIdentifier: "AccountVC") as! AccountVC
        AccountVC.tempArr = self.tempArr
        self.navigationController?.pushViewController(AccountVC, animated: false)
    }
    //    MARK:- tableView's methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
            return 84

    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
            return self.arrayOrders.count
            
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
            let cell_Add = tableView.dequeueReusableCell(withIdentifier: "OrderListCell", for: indexPath) as! OrderListCell
             cell_Add.btn_gotoorders.tag = indexPath.row
             cell_Add.btn_gotoorders.addTarget(self, action: #selector(btn_GotoOrders(_:)), for: .touchUpInside)
        
            cell_Add.img_order.layer.cornerRadius = cell_Add.img_order.layer.frame.height/2
             cell_Add.lbl_processing.layer.cornerRadius = cell_Add.lbl_processing.layer.frame.height/2
            cell_Add.img_order.clipsToBounds = true
             cell_Add.lbl_processing.clipsToBounds = true
        
            let str_orderID=self.arrayOrders[indexPath.row]["order_id"] as? String
            total_item=self.arrayOrders[indexPath.row]["total_item"] as! Int
            let str_orderstatus=self.arrayOrders[indexPath.row]["order_status"] as? String
           //  order_total_price =  self.arrayOrders[indexPath.row]["order_total_price"] as! Float
        
        
              order_total_price = Float(truncating:self.arrayOrders[indexPath.row]["order_total_price"] as! NSNumber)
             let total_item1 = String(total_item)
             let order_total_price1 = String(order_total_price)
        
//        let str_UserImage = self.arrayOrders[indexPath.row]["image"] as? String
//        cell_Add.img_order.sd_setImage(with: URL(string:str_UserImage!), placeholderImage: UIImage(named: "logo"))
        
            cell_Add.lbl_orderID.text =   "OrderID: " + str_orderID!
           cell_Add.lbl_totalitems.text =   total_item1 + " items"
            cell_Add.lbl_date.text =  self.arrayOrders[indexPath.row]["order_date"] as? String
           cell_Add.lbl_price.text  =   " GH₵ " + order_total_price1
            cell_Add.lbl_processing.text = self.arrayOrders[indexPath.row]["order_status"] as? String
             if str_orderstatus == "Pending"
             {
                cell_Add.lbl_processing.backgroundColor = UIColor(red: 216.0/255.0, green: 157.0/255.0, blue: 55.0/255.0, alpha: 1)
             }
            else if str_orderstatus == "Processing"
        
             {
                 cell_Add.lbl_processing.backgroundColor = UIColor(red: 216.0/255.0, green: 157.0/255.0, blue: 55.0/255.0, alpha: 1)
             }
             else if str_orderstatus == "Cancel"
             {
                cell_Add.lbl_processing.backgroundColor = UIColor(red: 224.0/255.0, green: 0.0/255.0, blue: 25.0/255.0, alpha: 1)
             }
             else
             {
               cell_Add.lbl_processing.backgroundColor = UIColor(red: 80.0/255.0, green: 145.0/255.0, blue: 58.0/255.0, alpha: 1)
              }
    
            return cell_Add
     
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
    @IBAction func btn_GotoOrders(_ sender: UIButton)
    {
         order_ID = (self.arrayOrders[sender.tag]["order_id"] as? String)!
        let OrderDetailsVC = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailsVC")
        self.present(OrderDetailsVC!, animated: true, completion: nil)
    }
    //****************************************************
    // MARK: - Memory CleanUP
    //****************************************************
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

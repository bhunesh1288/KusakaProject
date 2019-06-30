//
//  CartVC.swift
//  KUSAKA
//
//  Created by Rahul Mishra on 29/08/18.
//  Copyright © 2018 Rahul Mishra. All rights reserved.
//

import UIKit

class CartVC: UIViewController, UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var img_cart: UIImageView!
    @IBOutlet weak var lbl_countcart: UILabel!
    @IBOutlet weak var tbl_Cart: UITableView!
    @IBOutlet weak var view_tab: UIView!
    var tempArr = NSMutableArray()
    var arrCart = NSMutableArray()
    var datachoiceOptions = NSMutableArray()
    var sum: Float = 0
    var arrCartIds = NSMutableArray()
    var arrCartCounts = NSMutableArray()
    
    var arrPostdata = NSMutableArray()
    
    var arrCartsubtotaltemp = NSMutableArray()
    var arrCartsubtotal = NSMutableArray()
    var choice_options = ""
    
    
    var arrCell1DataNext = NSMutableArray()
    var arrCell2DataNext = NSMutableArray()
    var arrChawchawMenu1Next = NSMutableArray()
    var arrChawchawMenu2Next = NSMutableArray()
    
    var arrCart1 = NSMutableArray()
//    var arrCartIds = [Int]()
//    var arrCartCounts = [Int]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print(self.tempArr)
        
        
        if UserDefaults.standard.object(forKey: "highscore") != nil
        {
            
            self.lbl_countcart.text = UserDefaults.standard.value(forKey: "highscore") as? String
        }
       
        for i in 0..<tempArr.count
        {
            
           if (tempArr[i] as! NSDictionary).value(forKey: "count") as! Int != 0
           {
            
                 arrCart.add(tempArr[i])
        
            }
        
        }
        print(self.arrCart)
        
        
        

        for j in 0..<self.arrCart.count
        {
            datachoiceOptions = NSMutableArray()
            let int_SelectedId = ((arrCart[j] as! NSDictionary).value(forKey: "id") as! Int)
            let int_Counts = (((arrCart[j] as! NSDictionary).value(forKey: "count")) as! Float)
            let price = Float(truncating: (arrCart[j] as! NSDictionary).value(forKey: "price") as! NSNumber)
            //datachoiceOptions =  ((arrCart[j] as! NSDictionary).value(forKey: "data_choice_options")) as! NSMutableArray
            
    
            
            if let dataChoiceOptionsArray = ((arrCart[j] as! NSDictionary).value(forKey: "data_choice_options")) as? [[String:Any]]{
                 datachoiceOptions = NSMutableArray()
                choice_options = ""
                for dic in dataChoiceOptionsArray
                {

                      let value = dic["isSelected"] as! Int
                      let options = dic["options"] as! String
                    if value == 1
                    {
                        datachoiceOptions.add(options)
                         choice_options  = self.datachoiceOptions.componentsJoined(by: ",")
                    }

                }
            }
     
            print(self.datachoiceOptions)
            
            
           
            let pricesubtotal = int_Counts * price
            
            arrCartIds.add(int_SelectedId)
            arrCartCounts.add(int_Counts)
            arrCartsubtotal.add(pricesubtotal)
            
            let dict = [
                "item_id" : "\(int_SelectedId)",
                "item_quantity" : int_Counts,
                "choice_options" : "\(choice_options)"
                ] as [String : Any]
            arrPostdata.add(dict)
        }
        print(self.arrPostdata)
      
        for k in 0..<self.arrCart.count
        {
            if (arrCart[k] as! NSDictionary).value(forKey: "is_chawchaw_menu") as! Int == 0 && (arrCart[k] as! NSDictionary).value(forKey: "is_choice") as! Int == 1
            {
                self.arrCell2DataNext.add(self.arrCart[k])
            }
            if  (arrCart[k] as! NSDictionary).value(forKey: "is_chawchaw_menu") as! Int == 0 && (arrCart[k] as! NSDictionary).value(forKey: "is_choice") as! Int == 0
            {
                self.arrCell1DataNext.add(self.arrCart[k])
            }

            if  (arrCart[k] as! NSDictionary).value(forKey: "chawchaw_menus_option") as! Int == 1 && (arrCart[k] as! NSDictionary).value(forKey: "is_choice") as! Int == 1
            {
                self.arrChawchawMenu1Next.add(self.arrCart[k])
            }
            
            if (arrCart[k] as! NSDictionary).value(forKey: "chawchaw_menus_option") as! Int == 2 && (arrCart[k] as! NSDictionary).value(forKey: "is_choice") as! Int == 1
            {
                self.arrChawchawMenu2Next.add(self.arrCart[k])
            }
        }


        for x in 0..<arrCartsubtotal.count {
            sum += (arrCartsubtotal[x] as! Float)
        }

        print("SUM \(sum)")
        
       tbl_Cart.reloadData()

        view_tab.layer.shadowColor = UIColor.lightGray.cgColor
        view_tab.layer.shadowOpacity = 5.0
        view_tab.layer.shadowRadius = 5.0
        view_tab.layer.shadowOffset = CGSize (width: 1.5, height: 1.5)
        view_tab.layer.masksToBounds = false
        view_tab.layer.cornerRadius = 5.0
        

        tbl_Cart.tableFooterView = UIView()
       // self.tbl_Cart.addSubview(view_total)

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
    
    //****************************************************
    // MARK: - Action Method
    //****************************************************
    @IBAction func menu_Action(_ sender: Any)
    {
        let DashboardVC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC")
        self.navigationController?.pushViewController(DashboardVC!, animated: false)
        
        //self.navigationController?.popViewController(animated: false)
    }
    @IBAction func orders_Action(_ sender: Any)
    {

        let OrdersVC = self.storyboard?.instantiateViewController(withIdentifier: "OrdersVC") as! OrdersVC
        OrdersVC.tempArr = self.tempArr
        self.navigationController?.pushViewController(OrdersVC, animated: false)
    }
    @IBAction func account_Action(_ sender: Any)
    {

        let AccountVC = self.storyboard?.instantiateViewController(withIdentifier: "AccountVC") as! AccountVC
        AccountVC.tempArr = self.tempArr
        self.navigationController?.pushViewController(AccountVC, animated: false)
    }
    @IBAction func addmore_Action(_ sender: Any)
    {
        let DashboardVC = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC")
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.pushViewController(DashboardVC!, animated: true)
        
        
       // self.navigationController?.popViewController(animated: false)
    }
    @IBAction func checkout_Action(_ sender: Any)
    {
    
        if arrCart.count<=0 {
            
            CommenModel.showDefaltAlret(strMessage:"Please Select Products", controller: self)
            return
        }
       else if (UserDefaults.standard.value(forKey: "isLogin") as? Data) != nil
        {
           
            let CheckoutVC = self.storyboard?.instantiateViewController(withIdentifier: "CheckoutVC") as! CheckoutVC
            CheckoutVC.tempArr = self.tempArr
            CheckoutVC.arrPostdataOrders = self.arrPostdata
            self.navigationController?.pushViewController(CheckoutVC, animated: false)
        }
        else
        {
            let LoginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC")
            self.navigationController?.pushViewController(LoginVC!, animated: true)
        }
    
    }
    //    MARK:- tableView's methods
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 7
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0
            
        {
            return 115
            
        }
        else if indexPath.section==1
            
        {
            return 115
            
        }
        else if indexPath.section==2
            
        {
            return 61
            
        }
        else if indexPath.section==3
            
        {
            return 115
            
        }
        else if indexPath.section==4
            
        {
            return 61
            
        }
        else if indexPath.section==5
        {
            return 115
        }
        else
            
        {
            return 99
            
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       
        if section==0
            
        {
        
            
            return arrCell1DataNext.count
            
        }
        else if section==1
            
        {
         
            return arrCell2DataNext.count
            
        }
        else if section==2
            
        {
          
            
            if arrChawchawMenu1Next.count>0
            {
                  return 1
            }
            else
            {
                  return 0
            }
            
        }
        else if section==3
            
        {
         
            
             return arrChawchawMenu1Next.count
            
        }
        else if section==4
            
        {
          
            if arrChawchawMenu2Next.count>0
            {
                
                  return 1
            }
            else
            {
                  return 0
                
            }
            
        }
        else if section==5
        {
         
            
            return arrChawchawMenu2Next.count
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
        cell_Add.lbl_dishname.text = (arrCell1DataNext[indexPath.row] as! NSDictionary).value(forKey: "title") as? String
            
            
            let str_UserImage = (arrCell1DataNext[indexPath.row] as! NSDictionary).value(forKey: "image") as? String
            cell_Add.img_order.sd_setImage(with: URL(string:str_UserImage!), placeholderImage: UIImage(named: "logo"))
  
            let n = Float(truncating: (arrCell1DataNext[indexPath.row] as! NSDictionary).value(forKey: "price") as! NSNumber)
            
            let caculated = n * ((arrCell1DataNext[indexPath.row] as! NSDictionary).value(forKey: "count") as! Float)
            print(caculated)
            let pri = String(caculated)
            cell_Add.lbl_price.text = "GH₵ " + pri
            
            
            cell_Add.lbl_quantity.text = "GH₵ \((arrCell1DataNext[indexPath.row]  as! NSDictionary).value(forKey: "price") as! NSNumber) * \((arrCell1DataNext[indexPath.row] as! NSDictionary).value(forKey: "count") as! Int)"
            cell_Add.lbl_description.text = (arrCell1DataNext[indexPath.row] as! NSDictionary).value(forKey: "description") as? String

            

        return cell_Add
        }
        else if indexPath.section==1
            
        {
            let CartListCheckboxCell = tableView.dequeueReusableCell(withIdentifier: "CartListCheckboxCell", for: indexPath) as! CartListCheckboxCell
            
            CartListCheckboxCell.img_order.layer.cornerRadius = CartListCheckboxCell.img_order.layer.frame.height/2
            CartListCheckboxCell.img_order.clipsToBounds = true
            CartListCheckboxCell.lbl_dishname.text = (arrCell2DataNext[indexPath.row]  as! NSDictionary).value(forKey: "title") as? String
            
            
            let str_UserImage = (arrCell2DataNext[indexPath.row] as! NSDictionary).value(forKey: "image") as? String
            CartListCheckboxCell.img_order.sd_setImage(with: URL(string:str_UserImage!), placeholderImage: UIImage(named: "logo"))
            
            let n = Float(truncating: (arrCell2DataNext[indexPath.row] as! NSDictionary).value(forKey: "price") as! NSNumber)
            
            let caculated = n * ((arrCell2DataNext[indexPath.row] as! NSDictionary).value(forKey: "count") as! Float)
            print(caculated)
            let pri = String(caculated)
            CartListCheckboxCell.lbl_price.text = "GH₵ " + pri
            
            
            CartListCheckboxCell.lbl_quantity.text = "GH₵ \((arrCell2DataNext[indexPath.row] as! NSDictionary).value(forKey: "price") as! NSNumber) * \((arrCell2DataNext[indexPath.row] as! NSDictionary).value(forKey: "count") as! Int)"
            CartListCheckboxCell.lbl_description.text = (arrCell2DataNext[indexPath.row] as! NSDictionary).value(forKey: "description") as? String
            
            return CartListCheckboxCell
            
        }
        else if indexPath.section==2
            
        {
            let CartListOption1 = tableView.dequeueReusableCell(withIdentifier: "CartListOption1", for: indexPath) as! CartListOption1
            return CartListOption1
            
        }
        else if indexPath.section==3
            
        {
            let CartListOption1Details = tableView.dequeueReusableCell(withIdentifier: "CartListOption1Details", for: indexPath) as! CartListOption1Details
            
            CartListOption1Details.img_order.layer.cornerRadius = CartListOption1Details.img_order.layer.frame.height/2
            CartListOption1Details.img_order.clipsToBounds = true
            CartListOption1Details.lbl_dishname.text = (arrChawchawMenu1Next[indexPath.row] as! NSDictionary).value(forKey: "title") as? String
            
            
            let str_UserImage = (arrChawchawMenu1Next[indexPath.row] as! NSDictionary).value(forKey: "image") as? String
            CartListOption1Details.img_order.sd_setImage(with: URL(string:str_UserImage!), placeholderImage: UIImage(named: "logo"))
            
            let n = Float(truncating: (arrChawchawMenu1Next[indexPath.row] as! NSDictionary).value(forKey: "price") as! NSNumber)
            
            //  Float(truncating: self.return_Response[indexPath.row]["price"] as! NSNumber)
            
            let caculated = n * ((arrChawchawMenu1Next[indexPath.row] as! NSDictionary).value(forKey: "count") as! Float)
            print(caculated)
            let pri = String(caculated)
            CartListOption1Details.lbl_price.text = "GH₵ " + pri
            
            
            CartListOption1Details.lbl_quantity.text = "GH₵ \((arrChawchawMenu1Next[indexPath.row] as! NSDictionary).value(forKey: "price") as! NSNumber) * \((arrChawchawMenu1Next[indexPath.row] as! NSDictionary).value(forKey: "count") as! Int)"
            CartListOption1Details.lbl_description.text = (arrChawchawMenu1Next[indexPath.row] as! NSDictionary).value(forKey: "description") as? String
            
            return CartListOption1Details
            
        }
        else if indexPath.section==4
            
        {
            let CartListOption2 = tableView.dequeueReusableCell(withIdentifier: "CartListOption2", for: indexPath) as! CartListOption2
            return CartListOption2
            
        }
        else if indexPath.section==5
        {
            let CartListOption2Details = tableView.dequeueReusableCell(withIdentifier: "CartListOption2Details", for: indexPath) as! CartListOption2Details
            
            CartListOption2Details.img_order.layer.cornerRadius = CartListOption2Details.img_order.layer.frame.height/2
            CartListOption2Details.img_order.clipsToBounds = true
            CartListOption2Details.lbl_dishname.text = (arrChawchawMenu2Next[indexPath.row] as! NSDictionary).value(forKey: "title") as? String
            
            
            let str_UserImage = (arrChawchawMenu2Next[indexPath.row] as! NSDictionary).value(forKey: "image") as? String
            CartListOption2Details.img_order.sd_setImage(with: URL(string:str_UserImage!), placeholderImage: UIImage(named: "logo"))
            
            let n = Float(truncating: (arrChawchawMenu2Next[indexPath.row] as! NSDictionary).value(forKey: "price") as! NSNumber)
            
            //  Float(truncating: self.return_Response[indexPath.row]["price"] as! NSNumber)
            
            let caculated = n * ((arrChawchawMenu2Next[indexPath.row] as! NSDictionary).value(forKey: "count") as! Float)
            print(caculated)
            let pri = String(caculated)
            CartListOption2Details.lbl_price.text = "GH₵ " + pri
            
            
            CartListOption2Details.lbl_quantity.text = "GH₵ \((arrChawchawMenu2Next[indexPath.row] as! NSDictionary).value(forKey: "price") as! NSNumber) * \((arrChawchawMenu2Next[indexPath.row] as! NSDictionary).value(forKey: "count") as! Int)"
            CartListOption2Details.lbl_description.text = (arrChawchawMenu2Next[indexPath.row] as! NSDictionary).value(forKey: "description") as? String
            
            return CartListOption2Details
        }
        else
        {
            
            let cell_Add1 = tableView.dequeueReusableCell(withIdentifier: "CartTotalCell", for: indexPath) as! CartTotalCell
            
                  let cart_subtotal = String(sum)
            
                 cell_Add1.lbl_cartsubtotal.text = "GH₵ " + cart_subtotal
                cell_Add1.lbl_shipping.text = "Free"
                cell_Add1.lbl_ordertotal.text = "GH₵ " + cart_subtotal
           
            return cell_Add1
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
    //****************************************************
    // MARK: - Memory CleanUP
    //****************************************************

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

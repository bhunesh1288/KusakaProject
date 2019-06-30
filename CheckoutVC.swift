//
//  CheckoutVC.swift
//  KUSAKA
//
//  Created by Rahul Mishra on 29/08/18.
//  Copyright © 2018 Rahul Mishra. All rights reserved.
//

import UIKit
import Alamofire

var OrderIdMain = ""
var Totalamountsend = ""

class CheckoutVC: UIViewController, UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate {
    
    var firsname = ""
    var lastname = ""
    var companyname = ""
    var email = ""
    var phone = ""
    var address = ""
    

    var shiptick = ""
    

    var firsname1 = ""
    var lastname1 = ""
    var companyname1 = ""
    var email1 = ""
    var phone1 = ""
    var address1 = ""
    
    var othernotes = ""
    var tempArr = NSMutableArray()
     var arrCart = NSMutableArray()
    var arrCartsubtotal = NSMutableArray()
    var sum: Float = 0
    var modelMain:DeliveryMenu?
    
    var cashmoneycredit = ""
    var paymentmethod = "cod"
    

     @IBOutlet weak var tbl_checkout: UITableView!
     var isChecked: Bool = false
     private var toast: JYToast!
    
      var arrPostdataInfo = NSMutableArray()
      var arrPostdataOrders = NSMutableArray()
   
  
      override func viewDidLoad() {
        super.viewDidLoad()
         initUi()
        cashmoneycredit = "money"
        
    
        
        tbl_checkout.tableFooterView = UIView()
        is_this_address_shipping1 = 1
        is_this_address_shipping2  = 0
        
        for i in 0..<tempArr.count
        {
            
            if (tempArr[i] as! NSDictionary).value(forKey: "count") as! Int != 0
            {
                arrCart.add(tempArr[i])
                let int_Counts = (((arrCart[i] as! NSDictionary).value(forKey: "count")) as! Float)
                let price = Float(truncating: (arrCart[i] as! NSDictionary).value(forKey: "price") as! NSNumber)
                let pricesubtotal = int_Counts * price
                arrCartsubtotal.add(pricesubtotal)
            }
        }
        
        for x in 0..<arrCartsubtotal.count {
            sum += (arrCartsubtotal[x] as! Float)
        }
        
        print("SUM \(sum)")
        
        Totalamountsend = String(sum)
        
        print(Totalamountsend)

    }
    //****************************************************
    // MARK: - Custom Method
    //****************************************************
    private func initUi() {
        toast = JYToast()
    }       
     func validateMethod () -> Bool
     {
        guard  !(self.firsname).isBlank  else{
            CommenModel.showDefaltAlret(strMessage: "Please enter first name", controller: self)
            return false
        }
        guard  !(self.lastname).isBlank  else{
            CommenModel.showDefaltAlret(strMessage: "Please enter last name", controller: self)
            return false
        }
        guard  !(self.companyname).isBlank  else{
            CommenModel.showDefaltAlret(strMessage: "Please enter company name", controller: self)
            return false
        }
        guard  !(self.email).isBlank  else{
            CommenModel.showDefaltAlret(strMessage: "Please enter email ID", controller: self)
            return false
        }
        guard ((email.isValidEmail()))else {
            
            CommenModel.showDefaltAlret(strMessage: "Please enter valid email ID", controller: self)
            return false
            
        }
         guard  !(self.phone).isBlank  else{
            CommenModel.showDefaltAlret(strMessage:"Please enter phone number", controller: self)
            return false
        }
        guard  !(self.address).isBlank  else{
            CommenModel.showDefaltAlret(strMessage:"Please enter address", controller: self)
            return false
        }
       
        if shiptick == ""
        {
            
        }
        else
        {
            guard  !(self.firsname1).isBlank  else{
                CommenModel.showDefaltAlret(strMessage: "Please enter first name", controller: self)
                return false
            }
            guard  !(self.lastname1).isBlank  else{
                CommenModel.showDefaltAlret(strMessage: "Please enter last name", controller: self)
                return false
            }
            guard  !(self.companyname1).isBlank  else{
                CommenModel.showDefaltAlret(strMessage: "Please enter company name", controller: self)
                return false
            }
            guard  !(self.email1).isBlank  else{
                CommenModel.showDefaltAlret(strMessage: "Please enter email ID", controller: self)
                return false
            }
            guard ((email1.isValidEmail()))else {
                
                CommenModel.showDefaltAlret(strMessage: "Please enter valid email ID", controller: self)
                return false
                
            }
            guard  !(self.phone1).isBlank  else{
                CommenModel.showDefaltAlret(strMessage:"Please enter phone number", controller: self)
                return false
            }
            guard  !(self.address1).isBlank  else{
                CommenModel.showDefaltAlret(strMessage:"Please enter address", controller: self)
                return false
            }
        }
       
        guard CommenModel.isConnetctedToInternet() else{
            CommenModel.showDefaltAlret(strMessage:"Please check internet connection.", controller: self)
            return false
        }
        return  true
        
      }
    
    
    
    //****************************************************
    // MARK: - API Methods
    //****************************************************
    func checkoutApiCallMethods() {
        
        let deviceID = UIDevice.current.identifierForVendor!.uuidString
        print(deviceID)
        
        let dict = [
            "firstname":firsname,
            "lastname":lastname,
            "company":companyname,
            "email":email,
            "contact_no":phone,
            "country":"101",
            "address":address,
            "is_this_address_shipping": is_this_address_shipping1,
            "ship_to_diffrent_address":is_this_address_shipping2,
            "shipping_firstname":firsname1,
            "shipping_lastname":lastname1,
            "shipping_company":companyname1,
            "shipping_email":email1,
            "shipping_contact":phone1,
            "shipping_country":"101",
            "shipping_address":address1,
            "order_note":othernotes,
    
            ] as [String : Any]
        
         arrPostdataInfo.add(dict)
        print(dict)

        let setparameters = [
            "BillingInfo" : dict,
            "orders":arrPostdataOrders,
            "payment_method":paymentmethod,
            ] as [String : Any]
        

        print(setparameters)
        
        var _: Error? = nil
        let jsonData: Data? = try? JSONSerialization.data(withJSONObject: setparameters, options: .prettyPrinted)
        
       // let json = try! JSONSerialization.data(withJSONObject: setparameters, options: .allowCommentsAndWhitespace)
        
   

        let postdata: [String: Any] = [
            "alldata": jsonData ?? "nil",
        ]
        print(postdata)
        
    
        let str_FullUrl = "user/test-checkout"+"?access_token=\(UserModel.sharedInstance.auth_Key)"
        print("str_FullUrl is:-",str_FullUrl)
        
        AutoBcmLoadingView.show("Loading......")
        
        let headers = [
            "Content-Type": "application/json"
        ]
        
        Alamofire.SessionManager.default.request(str_FullUrl, method: .post,parameters: setparameters, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            print(response.request ?? "no request")  // original URL request
            if(response.response?.statusCode != nil){
                
                                                        AutoBcmLoadingView.dismiss()
                
                
                
                                                    //getting the json value from the server
                                                    let result = response.result.value
                                                    let jsonData = result as! NSDictionary //This is where the error occcurs
                                                                    
                                                              
                
                                                        let success=jsonData["success"] as!   Int
                                                        let message=jsonData["message"] as!   String
                
                                                        if success==1
                                                        {
                                                         
                                                             let dict_Data = jsonData["data"] as! NSDictionary
                                                            
                                                            print(dict_Data)
                                                          
                                                            let orders=dict_Data["orders"] as!   NSDictionary
                                                            
                                                             OrderIdMain=orders["order_id"] as!   String
                                                            print(OrderIdMain)
                                                            
                                                            if self.cashmoneycredit == "cash"
                                                            {
                                                                
                                                                if let model=Utility.removeDeliveryMenuModel(){
                                                                    self.modelMain=model
                                                                }
                                                                
                                                                let userDefaults = UserDefaults.standard
                                                                userDefaults.removeObject(forKey: "highscore")
                                                                userDefaults.synchronize()
                                                              
                                                                let GotoOrdersVC = self.storyboard?.instantiateViewController(withIdentifier: "GotoOrdersVC")
                                                                self.navigationController?.pushViewController(GotoOrdersVC!, animated: true)
                                                                
                                                                self.toast.isShow(message)
                                                                self.dismiss(animated: true, completion: nil)
                                                            }
                                                            else
                                                            {
                                                                let WebCheckoutVC = self.storyboard?.instantiateViewController(withIdentifier: "WebCheckoutVC")
                                                                self.navigationController?.pushViewController(WebCheckoutVC!, animated: true)
                                                            }

                
                                                           
                
                
                                                            
                                                        }
                
                                                        else
                                                        {
                                                            self.toast.isShow(message)
                
                                                        }
               
            } else {
                print("gone")
                AutoBcmLoadingView.dismiss()
              //  return completionHandler(JSON.null, true)
            }}
    
    }
    
    
    
    
    //****************************************************
    // MARK: - Action Method
    //****************************************************
    @IBAction func back_Action(_ sender: Any)
    {
      //  self.dismiss(animated: true, completion: nil)
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromBottom
        navigationController?.view.layer.add(transition, forKey:kCATransition)
        navigationController?.popViewController(animated: false)
    }

    
    @IBAction func proceedtopayment_Action(_ sender: Any)
    {
        guard validateMethod() else {
            return
        }
       
        
        
        if cashmoneycredit == "cash"
        {
             self.checkoutApiCallMethods()
        }
        else
        {
//            let WebCheckoutVC = self.storyboard?.instantiateViewController(withIdentifier: "WebCheckoutVC")
//            self.navigationController?.pushViewController(WebCheckoutVC!, animated: true)
            
            self.checkoutApiCallMethods()
        }
       
        
    
    }
    
    
    //    MARK:- tableView's methods
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0
            
        {
            return 420
            
        }
        else if indexPath.section == 1
            
        {
            if shiptick == ""
            {
                return 0
            }
            else
            {
                return 317
            }
            
            
        }
        else if indexPath.section == 2
            
        {
            return 243
            
        }
//        else if indexPath.section == 3
//
//        {
//            return 26
//
//        }
        else if indexPath.section == 3
            
        {
            return 99
            
        }
        else
            
        {
            return 127
            
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 5
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if section==0
            
        {
            return 1
            
        }
        else  if section==1
            
        {
        
            if shiptick == ""
            {
                return 0
            }
            else
            {
                return 1
            }
            
            
        }
        else  if section==2
            
        {
            return 1
            
        }
//      else  if section==3
//
//        {
//            return arrCart.count
//
//        }
        else if section==3
            
        {
            return 1
            
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
            let cell_Add = tableView.dequeueReusableCell(withIdentifier: "CheckoutCell1", for: indexPath) as! CheckoutCell1
            cell_Add.img1.layer.cornerRadius = cell_Add.img1.layer.frame.height/2
            cell_Add.img2.layer.cornerRadius = cell_Add.img2.layer.frame.height/2
            cell_Add.img3.layer.cornerRadius = cell_Add.img3.layer.frame.height/2
            cell_Add.img4.layer.cornerRadius = cell_Add.img4.layer.frame.height/2
            cell_Add.img5.layer.cornerRadius = cell_Add.img5.layer.frame.height/2
            
            cell_Add.btn_ship.tag = indexPath.row
            cell_Add.btn_ship.addTarget(self, action: #selector(btn_ShipAction(_:)), for: .touchUpInside)
        
            
             cell_Add.txtFiedFirstname.delegate = self
             cell_Add.txtFiedLastname.delegate = self
             cell_Add.txtFiedCompanyname.delegate = self
             cell_Add.txtFiedEmail.delegate = self
             cell_Add.txtFiedPhone.delegate = self
            cell_Add.txtview_address.delegate = self
        
            
            
            
            cell_Add.img7.layer.cornerRadius = 8
      
            
            cell_Add.img1.layer.borderWidth = 1
            cell_Add.img1.layer.borderColor = (UIColor .init(red: 225.0/255.0, green: 225.0/255.0, blue: 225.0/255.0, alpha: 1)).cgColor
            
            cell_Add.img2.layer.borderWidth = 1
            cell_Add.img2.layer.borderColor = (UIColor .init(red: 225.0/255.0, green: 225.0/255.0, blue: 225.0/255.0, alpha: 1)).cgColor
            
            cell_Add.img3.layer.borderWidth = 1
            cell_Add.img3.layer.borderColor = (UIColor .init(red: 225.0/255.0, green: 225.0/255.0, blue: 225.0/255.0, alpha: 1)).cgColor
            
            cell_Add.img4.layer.borderWidth = 1
            cell_Add.img4.layer.borderColor = (UIColor .init(red: 225.0/255.0, green: 225.0/255.0, blue: 225.0/255.0, alpha: 1)).cgColor
            
            cell_Add.img5.layer.borderWidth = 1
            cell_Add.img5.layer.borderColor = (UIColor .init(red: 225.0/255.0, green: 225.0/255.0, blue: 225.0/255.0, alpha: 1)).cgColor
            

            
            cell_Add.img7.layer.borderWidth = 1
            cell_Add.img7.layer.borderColor = (UIColor .init(red: 225.0/255.0, green: 225.0/255.0, blue: 225.0/255.0, alpha: 1)).cgColor
            

           
            if shiptick == ""
            {
            
                cell_Add.img_check.image=UIImage(named: "check")
            }
            else
            {
              
                cell_Add.img_check.image=UIImage(named: "check_selected")
            }
            cell_Add.img1.clipsToBounds = true
            cell_Add.img2.clipsToBounds = true
            cell_Add.img3.clipsToBounds = true
            cell_Add.img4.clipsToBounds = true
            cell_Add.img5.clipsToBounds = true
            cell_Add.img7.clipsToBounds = true
          
            
            return cell_Add
        }
        else if indexPath.section == 1
        {
            let ShipOtherCell = tableView.dequeueReusableCell(withIdentifier: "ShipOtherCell", for: indexPath) as! ShipOtherCell
            
            ShipOtherCell.img1.layer.cornerRadius = ShipOtherCell.img1.layer.frame.height/2
            ShipOtherCell.img2.layer.cornerRadius = ShipOtherCell.img2.layer.frame.height/2
            ShipOtherCell.img3.layer.cornerRadius = ShipOtherCell.img3.layer.frame.height/2
            ShipOtherCell.img4.layer.cornerRadius = ShipOtherCell.img4.layer.frame.height/2
            ShipOtherCell.img5.layer.cornerRadius = ShipOtherCell.img5.layer.frame.height/2
            
           
            
            
            ShipOtherCell.txtFiedFirstname.delegate = self
            ShipOtherCell.txtFiedLastname.delegate = self
            ShipOtherCell.txtFiedCompanyname.delegate = self
            ShipOtherCell.txtFiedEmail.delegate = self
            ShipOtherCell.txtFiedPhone.delegate = self
            ShipOtherCell.txtview_address.delegate = self
            
            
            
            
            ShipOtherCell.img7.layer.cornerRadius = 8
            
            
            ShipOtherCell.img1.layer.borderWidth = 1
            ShipOtherCell.img1.layer.borderColor = (UIColor .init(red: 225.0/255.0, green: 225.0/255.0, blue: 225.0/255.0, alpha: 1)).cgColor
            
            ShipOtherCell.img2.layer.borderWidth = 1
            ShipOtherCell.img2.layer.borderColor = (UIColor .init(red: 225.0/255.0, green: 225.0/255.0, blue: 225.0/255.0, alpha: 1)).cgColor
            
            ShipOtherCell.img3.layer.borderWidth = 1
            ShipOtherCell.img3.layer.borderColor = (UIColor .init(red: 225.0/255.0, green: 225.0/255.0, blue: 225.0/255.0, alpha: 1)).cgColor
            
            ShipOtherCell.img4.layer.borderWidth = 1
            ShipOtherCell.img4.layer.borderColor = (UIColor .init(red: 225.0/255.0, green: 225.0/255.0, blue: 225.0/255.0, alpha: 1)).cgColor
            
            ShipOtherCell.img5.layer.borderWidth = 1
            ShipOtherCell.img5.layer.borderColor = (UIColor .init(red: 225.0/255.0, green: 225.0/255.0, blue: 225.0/255.0, alpha: 1)).cgColor
            
            
            
            ShipOtherCell.img7.layer.borderWidth = 1
            ShipOtherCell.img7.layer.borderColor = (UIColor .init(red: 225.0/255.0, green: 225.0/255.0, blue: 225.0/255.0, alpha: 1)).cgColor
            ShipOtherCell.img1.clipsToBounds = true
            ShipOtherCell.img2.clipsToBounds = true
            ShipOtherCell.img3.clipsToBounds = true
            ShipOtherCell.img4.clipsToBounds = true
            ShipOtherCell.img5.clipsToBounds = true
            ShipOtherCell.img7.clipsToBounds = true
            return ShipOtherCell
        }
        else if indexPath.section == 2
        {
            let OtherNotesCell = tableView.dequeueReusableCell(withIdentifier: "OtherNotesCell", for: indexPath) as! OtherNotesCell

             OtherNotesCell.txtview_otheraddress.delegate = self
             OtherNotesCell.img1.layer.borderWidth = 1
             OtherNotesCell.img1.layer.cornerRadius = 8
             OtherNotesCell.img1.layer.borderColor = (UIColor .init(red: 225.0/255.0, green: 225.0/255.0, blue: 225.0/255.0, alpha: 1)).cgColor
             OtherNotesCell.img1.clipsToBounds = true

            return OtherNotesCell
        }
//       else if indexPath.section == 2
//        {
//            let cell_Add1 = tableView.dequeueReusableCell(withIdentifier: "CheckoutCell2", for: indexPath) as! CheckoutCell2
//            
//            cell_Add1.lbl_dishname.text = ((arrCart[indexPath.row] as! NSDictionary).value(forKey: "details") as! NSDictionary).value(forKey: "title") as? String
//            
//            
//            let n = Float(truncating: ((arrCart[indexPath.row] as! NSDictionary).value(forKey: "details") as! NSDictionary).value(forKey: "price") as! NSNumber)
//            let caculated = n * ((arrCart[indexPath.row] as! NSDictionary).value(forKey: "count") as! Float)
//            print(caculated)
//            let pri = String(caculated)
//            cell_Add1.lbl_price.text = "GH₵ " + pri
//            
//            
//            cell_Add1.lbl_quantity.text = "\((arrCart[indexPath.row] as! NSDictionary).value(forKey: "count") as! Int)"
//            
//            return cell_Add1
//        }
      else  if indexPath.section == 3
        {
            let cell_Add2 = tableView.dequeueReusableCell(withIdentifier: "CheckoutCell3", for: indexPath) as! CheckoutCell3
            
            let cart_subtotal = String(sum)
            
            cell_Add2.lbl_cartsubtotal.text = "GH₵ " + cart_subtotal
            cell_Add2.lbl_shipping.text = "Free"
            cell_Add2.lbl_ordertotal.text = "GH₵ " + cart_subtotal
            
            
            return cell_Add2
        }
        else
        {
            
            let cell_Add3 = tableView.dequeueReusableCell(withIdentifier: "CheckoutCell4", for: indexPath) as! CheckoutCell4
            
            cell_Add3.btn_cash.addTarget(self, action: #selector(btn_cashAction(_:)), for: .touchUpInside)
            cell_Add3.btn_money.addTarget(self, action: #selector(btn_moneyAction(_:)), for: .touchUpInside)
           // cell_Add3.btn_credit.addTarget(self, action: #selector(btn_creditAction(_:)), for: .touchUpInside)
            
            if cashmoneycredit == "cash"
            {
                 cell_Add3.img_cash.image=UIImage(named: "radio_selected")
                 cell_Add3.img_money.image=UIImage(named: "radio")
               // cell_Add3.img_credit.image=UIImage(named: "radio")
            }
            if cashmoneycredit == "money"
            {
                cell_Add3.img_money.image=UIImage(named: "radio_selected")
                cell_Add3.img_cash.image=UIImage(named: "radio")
             //   cell_Add3.img_credit.image=UIImage(named: "radio")
            }

//            if cashmoneycredit == "credit"
//            {
//                cell_Add3.img_credit.image=UIImage(named: "radio_selected")
//                cell_Add3.img_money.image=UIImage(named: "radio")
//                cell_Add3.img_cash.image=UIImage(named: "radio")
//            }
            return cell_Add3
        }
    }
    
    @IBAction func btn_ShipAction(_ sender: UIButton)
    {
            if isChecked == true {
                isChecked = false
                
                is_this_address_shipping1 = 1
                is_this_address_shipping2  = 0
                
                shiptick = ""
                tbl_checkout.reloadData()
                
//                let lastScrollOffset = tbl_checkout.contentOffset
//
//                tbl_checkout.beginUpdates()
//                tbl_checkout.reloadSections(IndexSet(integer: 1), with: .none)
//                tbl_checkout.endUpdates()
//
//                tbl_checkout.layer.removeAllAnimations()
//                tbl_checkout.setContentOffset(lastScrollOffset, animated: false)
                
            } else {
                isChecked = true
                
                is_this_address_shipping1 = 0
                is_this_address_shipping2  = 1
                
                shiptick = "shiptick"
               tbl_checkout.reloadData()
//                let lastScrollOffset = tbl_checkout.contentOffset
//
//                tbl_checkout.beginUpdates()
//                tbl_checkout.reloadSections(IndexSet(integer: 1), with: .none)
//                tbl_checkout.endUpdates()
//
//                tbl_checkout.layer.removeAllAnimations()
//                tbl_checkout.setContentOffset(lastScrollOffset, animated: false)
            }
    
    }
    @IBAction func btn_cashAction(_ sender: UIButton)
    {
        cashmoneycredit = "cash"
        paymentmethod = "cod"
        let lastScrollOffset = tbl_checkout.contentOffset
        
        tbl_checkout.beginUpdates()
        tbl_checkout.reloadSections(IndexSet(integer: 4), with: .none)
        tbl_checkout.endUpdates()
        
        tbl_checkout.layer.removeAllAnimations()
        tbl_checkout.setContentOffset(lastScrollOffset, animated: false)
   
    }
    @IBAction func btn_moneyAction(_ sender: UIButton)
    {
        cashmoneycredit = "money"
        paymentmethod = "interpay"
 
        let lastScrollOffset = tbl_checkout.contentOffset
        
        tbl_checkout.beginUpdates()
        tbl_checkout.reloadSections(IndexSet(integer: 4), with: .none)
        tbl_checkout.endUpdates()
        
        tbl_checkout.layer.removeAllAnimations()
        tbl_checkout.setContentOffset(lastScrollOffset, animated: false)
      
    }
    @IBAction func btn_creditAction(_ sender: UIButton)
    {
        cashmoneycredit = "credit"
        
        let lastScrollOffset = tbl_checkout.contentOffset
        
        tbl_checkout.beginUpdates()
        tbl_checkout.reloadSections(IndexSet(integer: 4), with: .none)
        tbl_checkout.endUpdates()
        
        tbl_checkout.layer.removeAllAnimations()
        tbl_checkout.setContentOffset(lastScrollOffset, animated: false)
  
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {    //delegate method
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool
    {
        
        if (textField.tag==1)
        {
            firsname=textField.text!
            
        }
        else if (textField.tag==2)
        {
            
            lastname=textField.text!
        }
        else if (textField.tag==3)
        {
            
            companyname=textField.text!
        }
        else if (textField.tag==4)
        {
            
            email=textField.text!
        }
        else if (textField.tag==5)
        {
            
            phone=textField.text!
        }
       else if (textField.tag==7)
        {
            firsname1=textField.text!
            
        }
        else if (textField.tag==8)
        {
            
            lastname1=textField.text!
        }
        else if (textField.tag==9)
        {
            
            companyname1=textField.text!
        }
        else if (textField.tag==10)
        {
            
            email1=textField.text!
        }
        else if (textField.tag==11)
        {
            
            phone1=textField.text!
        }
        
       // return YES;
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        DispatchQueue.main.async
            {
                    if (textView.tag==6)
                    {
                        if textView.text == "Address"
                        {
                            textView.text = ""
                            textView.textColor = UIColor.darkGray
                        }
                        
                        self.address=textView.text!
                        
                    }
                if (textView.tag==12)
                {
                    if textView.text == "Address"
                    {
                        textView.text = ""
                        textView.textColor = UIColor.darkGray
                    }
                    
                    self.address1=textView.text!
                    
                }
                if (textView.tag==13)
                {
                    if textView.text == "Other Notes"
                    {
                        textView.text = ""
                        textView.textColor = UIColor.darkGray
                    }
                    
                    self.othernotes=textView.text!
                    
                }
       }
    }
    internal func textViewDidEndEditing(_ textView: UITextView)
    {

        if (textView.tag==6)
        {
            if textView.text == ""
            {
                textView.text = "Address"
                textView.textColor = UIColor.lightGray
            }
            
            self.address=textView.text!
            
        }
        if (textView.tag==12)
        {
            if textView.text == ""
            {
                textView.text = "Address"
                textView.textColor = UIColor.lightGray
            }
            
            self.address1=textView.text!
            
        }
        if (textView.tag==13)
        {
            if textView.text == ""
            {
                textView.text = "Other Notes"
                textView.textColor = UIColor.lightGray
            }
            
            self.othernotes=textView.text!
            
        }

    }
    
    //****************************************************
    // MARK: - Memory CleanUP
    //****************************************************
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
